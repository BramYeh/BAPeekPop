//
//  BAPeekPop.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "BAPeekPop+Private.h"
#import "BAPreviewingViewController+Private.h"
#import "BAViewControllerPreviewingContext.h"

@interface BAPeekPop () <BAPreviewingViewControllerDelegate>

// initialized target view controller
@property (nonatomic, weak) UIViewController *targetController;
@property (nonatomic, weak) id <UIViewControllerPreviewingDelegate> delegate;
@property (nonatomic, weak) UIView *sourceView;

// force touch parameter
@property (nonatomic, strong) id <UIViewControllerPreviewing> previewingContext;
@property (nonatomic, assign) CGPoint startPoint;
// long press and its mouse moving
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
// pan gesture
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecongnizer;
//
@property (nonatomic, strong) BAPreviewingViewController *previewingViewController;

@end

@implementation BAPeekPop

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithTarget:nil];
}

- (instancetype)initWithTarget:(UIViewController *)targetController {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_x_Max) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.targetController = targetController;
    }
    return self;
}

#pragma mark - Public Method

- (id <UIViewControllerPreviewing>)registerForPreviewingWithDelegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView {
    // register for 3D Touch (if available)
    if ([self isForceTouchAvailable]) {
        self.previewingContext = [self.targetController registerForPreviewingWithDelegate:delegate sourceView:sourceView];
        
    } else {
        self.delegate = delegate;
        self.sourceView = sourceView;
        
        self.longPressGestureRecognizer = ({
            UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
            longPressRecognizer.cancelsTouchesInView = NO;
            longPressRecognizer.delaysTouchesBegan = YES;
            longPressRecognizer;
        });
        
        [self.sourceView addGestureRecognizer:self.longPressGestureRecognizer];
        
        self.previewingContext = [[BAViewControllerPreviewingContext alloc] initWithGestureRecognizer:self.longPressGestureRecognizer
                                                                                             delegate:self.delegate
                                                                                           sourceView:self.sourceView];
    }
    
    return self.previewingContext;
}

- (void)unregisterForPreviewingWithContext:(id <UIViewControllerPreviewing>)previewing {
    if ([self isForceTouchAvailable]) {
        [self.targetController unregisterForPreviewingWithContext:previewing];
        
    } else {
        // remove long press gesture
        self.longPressGestureRecognizer.enabled = NO;
        [self.sourceView removeGestureRecognizer:self.longPressGestureRecognizer];
        self.longPressGestureRecognizer = nil;
    }
}

#pragma mark - BAPeekPop

- (BOOL)isForceTouchAvailable {
    BOOL isForceTouchAvailable = NO;
    if ([self.targetController.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
        isForceTouchAvailable = (self.targetController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable);
    }
    return isForceTouchAvailable;
}

#pragma mark - Gesture Handler

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer != self.longPressGestureRecognizer) {
        return;
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (self.previewingViewController) {
                return;
            }
            
            // 1. query viewControllerForLocation from delegate
            CGPoint pointInSourceView = [gestureRecognizer locationInView:self.sourceView];
            UIViewController *peekViewController = [self.delegate previewingContext:self.previewingContext viewControllerForLocation:pointInSourceView];
            if (!peekViewController) {
                return;
            }
            
            
            // 2. init BAPreviewingViewController
            // 3. display BAPreviewingViewController
            [self presentPreviewingViewController:peekViewController sourcePoint:pointInSourceView];
            
            // 4. record first touch point
            self.startPoint = pointInSourceView;
            [self.previewingViewController startPeek];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint pointInSourceView = [gestureRecognizer locationInView:self.sourceView];
            [self.previewingViewController handlePeekWithOffset:CGVectorMake(pointInSourceView.x - self.startPoint.x, pointInSourceView.y - self.startPoint.y)];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [self.previewingViewController stopPeek];
            if (self.previewingViewController.isActionBottonDisplayed) {
                self.longPressGestureRecognizer.enabled = NO;
                self.panGestureRecongnizer.enabled = YES;
            }
        }
            break;
        default:
            break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!self.previewingViewController) {
        self.longPressGestureRecognizer.enabled = YES;
        return;
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            // if pan gesture is outer of peekViewController or action button
            // it should dismiss current BAPreviewingViewController
            CGPoint pointInView = [gestureRecognizer locationInView:self.previewingViewController.view];
            if (![self.previewingViewController isTouchPointInView:pointInView]) {
                [self dismissPreviewingViewController];
                return;
            }
            [self.previewingViewController startPeek];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint offset = [gestureRecognizer translationInView:self.previewingViewController.view];
            [self.previewingViewController handlePeekWithOffset:CGVectorMake(offset.x, offset.y)];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [self.previewingViewController stopPeek];
            if (self.previewingViewController.isActionBottonDisplayed) {
                self.longPressGestureRecognizer.enabled = NO;
                self.panGestureRecongnizer.enabled = YES;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - BAPeekPop+Private
- (UIViewController *)topmostViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (void)presentPreviewingViewController:(UIViewController *)contentViewController sourcePoint:(CGPoint)sourcePoint {
    // 1. init BAPreviewingViewController
    self.previewingViewController = [[BAPreviewingViewController alloc] initWithPeekViewController:contentViewController context:self.previewingContext sourcePoint:sourcePoint];
    self.previewingViewController.delegate = self;
    
    self.panGestureRecongnizer = ({
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panRecognizer.cancelsTouchesInView = NO;
        panRecognizer.delaysTouchesBegan = YES;
        panRecognizer.enabled = NO;
        panRecognizer;
    });
    
    [self.previewingViewController.view addGestureRecognizer:self.panGestureRecongnizer];
    
    // 2. display BAPreviewingViewController
    // addChildViewController: will call [child willMoveToParentViewController:self] before adding the child
    UIViewController *topmostViewController = self.topmostViewController;
    [topmostViewController addChildViewController:self.previewingViewController];
    [topmostViewController.view addSubview:self.previewingViewController.view];
    [self.previewingViewController didMoveToParentViewController:topmostViewController];
}

- (void)dismissPreviewingViewController {
    if (!self.previewingViewController) {
        return;
    }

    // remove pan gesture
    self.panGestureRecongnizer.enabled = NO;
    [self.previewingViewController.view removeGestureRecognizer:self.panGestureRecongnizer];
    self.panGestureRecongnizer = nil;
    
    // remove previewing viewcontroller
    [self.previewingViewController willMoveToParentViewController:nil];
    [self.previewingViewController.view removeFromSuperview];
    [self.previewingViewController removeFromParentViewController];
    self.previewingViewController = nil;
    
    // enable long press gesture
    self.longPressGestureRecognizer.enabled = YES;
}

#pragma mark - BAPreviewingViewControllerDelegate

- (void)previewingViewControllerDidDismiss:(BAPreviewingViewController *)previewingViewController {
    if (self.previewingViewController == previewingViewController) {
        [self dismissPreviewingViewController];
    }
}

@end


#pragma mark - BAPreviewAction

@implementation BAPreviewAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIPreviewActionStyle)style handler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))handler {
    BAPreviewAction *action = [super actionWithTitle:title style:style handler:handler];
    if (action) {
        action.style = style;
    }
    return action;
}

@end


#pragma mark - BAPreviewActionGroup

@implementation BAPreviewActionGroup

+ (instancetype)actionGroupWithTitle:(NSString *)title style:(UIPreviewActionStyle)style actions:(NSArray<BAPreviewAction *> *)actions {
    BAPreviewActionGroup *actionGroup = [super actionGroupWithTitle:title style:style actions:actions];
    if (actionGroup) {
        actionGroup.style = style;
        actionGroup.actions = actions;
    }
    return actionGroup;
}

@end
