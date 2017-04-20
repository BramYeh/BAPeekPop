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
//
@property (nonatomic, readonly) BAPreviewingViewController *previewingViewController;

- (instancetype)initWithTarget:(UIViewController *)targetController NS_DESIGNATED_INITIALIZER;

- (id <UIViewControllerPreviewing>)registerForPreviewingWithDelegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView;
- (void)unregisterForPreviewingWithContext:(id <UIViewControllerPreviewing>)previewing;

- (void)presentPreviewingViewController:(UIViewController *)contentViewController sourcePoint:(CGPoint)sourcePoint;
- (void)dismissPreviewingViewController;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewAction : UIPreviewAction

@property(nonatomic, assign, readonly) UIPreviewActionStyle style;

+ (instancetype)actionWithTitle:(NSString *)title style:(UIPreviewActionStyle)style handler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))handler;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewActionGroup : UIPreviewActionGroup

+ (instancetype)actionGroupWithTitle:(NSString *)title style:(UIPreviewActionStyle)style actions:(NSArray<BAPreviewAction *> *)actions;

@end
