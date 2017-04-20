//
//  BAPeekPop.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BAPreviewingViewController.h"

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPeekPop : NSObject

// force touch parameter
@property (nonatomic, readonly) id <UIViewControllerPreviewing> previewingContext;
@property (nonatomic, readonly) CGPoint startPoint;
// long press and its mouse moving
@property (nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
// pan gesture
@property (nonatomic, readonly) UIPanGestureRecognizer *panGestureRecongnizer;
// customize previewing viewcontroller
@property (nonatomic, readonly) BAPreviewingViewController *previewingViewController;

/**
 Default initialization method to create BAPeekPop

 @param targetController the viewcontroller on which you want the BAPeekPop to support Peek & Pop feature
 @return BAPeekPop instance
 */
- (instancetype)initWithTarget:(UIViewController *)targetController NS_DESIGNATED_INITIALIZER;

/**
 Registers a view controller to participate with 3D Touch preview (peek) and commit (pop).

 @param delegate The delegate object mediates the presentation of views from the preview (peek) view controller and the commit (pop) view controller. In practice, these two are typically the same view controller. The delegate performs this mediation through your implementation of the methods of the UIViewControllerPreviewingDelegate protocol.
 @param sourceView The view, in the view hierarchy of the receiver of this method call, that invokes a preview when pressed by the user. When lightly pressed, the source view remains visually sharp while surrounding content blurs. When pressed more deeply, the system calls the previewingContext:viewControllerForLocation: method in your delegate object, which presents the preview (peek) view from another view controller.
 @return A context object for managing the preview. This object conforms to the UIViewControllerPreviewing protocol.
 
 @see {@link https://developer.apple.com/reference/uikit/uiviewcontroller/1621463-registerforpreviewingwithdelegat|Apple API Reference}
 */
- (id <UIViewControllerPreviewing>)registerForPreviewingWithDelegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView;
/**
 Unregisters a previously registered view controller identified by its context object.

 @param previewing The context object that was returned when you registered the view controller by calling the register​For​Previewing​With​Delegate:​source​View:​ method.
 
 @see {@link https://developer.apple.com/reference/uikit/uiviewcontroller/1621395-unregisterforpreviewingwithconte|Apple API Reference}
 */
- (void)unregisterForPreviewingWithContext:(id <UIViewControllerPreviewing>)previewing;

/**
 <#Description#>

 @param contentViewController <#contentViewController description#>
 @param sourcePoint <#sourcePoint description#>
 */
- (void)presentPreviewingViewController:(UIViewController *)contentViewController sourcePoint:(CGPoint)sourcePoint;
/**
 <#Description#>
 */
- (void)dismissPreviewingViewController;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewAction : UIPreviewAction

@property(nonatomic, assign, readonly) UIPreviewActionStyle style;

+ (instancetype)actionWithTitle:(NSString *)title style:(UIPreviewActionStyle)style handler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))handler;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewActionGroup : UIPreviewActionGroup

+ (instancetype)actionGroupWithTitle:(NSString *)title style:(UIPreviewActionStyle)style actions:(NSArray<BAPreviewAction *> *)actions;

@end
