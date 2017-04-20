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

 @param targetController The viewcontroller on which you want the BAPeekPop to support Peek & Pop feature.
 @return BAPeekPop instance.
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
 Make this function available to other files to be able to use the peekpop view in MKAnnotations since annotations cannot detect long tap gestures using BAPeekPop. However, I would strongly recommend not to call this method directly.

 @param contentViewController The viewcontrooller that actually application offers.
 @param sourcePoint The point, that previewing viewcontroller would animate to pop up from this point.
 */
- (void)presentPreviewingViewController:(UIViewController *)contentViewController sourcePoint:(CGPoint)sourcePoint;
/**
 Make this function available to other files to be able to use the peekpop view in MKAnnotations since annotations cannot detect long tap gestures using BAPeekPop. However, I would strongly recommend not to call this method directly.
 */
- (void)dismissPreviewingViewController;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewAction : UIPreviewAction

@property(nonatomic, assign, readonly) UIPreviewActionStyle style;

/**
 Initialization method to create BAPreviewAction which inherits UIPreviewAction, which is a peek quick action using a specified title, style, and handler.

 @param title The quick action’s title.
 @param style The quick action’s style. For a complete list of styles, see the UIPreviewActionStyle enumeration in UIPreviewActionItem Protocol Reference.
 @param handler A block that is called when the user selects the peek quick action.
 @return A newly-created peek quick action, which inherits UIPreviewAction.
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(UIPreviewActionStyle)style handler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))handler;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewActionGroup : UIPreviewActionGroup

/**
 Initialization method to create BAPreviewActionGroup which inherits UIPreviewActionGroup, which is a preview quick action group contains one or more child quick actions, each an instance of the BAPreviewAction class.

 @param title The peek quick action group’s title.
 @param style The style for the peek quick action group. When the system presents the group’s submenu, each child quick action is displayed using its own style. The available styles are described in the UIPreviewActionStyle enumeration in UIPreviewActionItem.
 @param actions An array of UIPreviewAction objects, displayed as the child quick actions for the peek quick action group.
 @return A newly initialized peek quick action group, which inherits UIPreviewActionGroup.
 */
+ (instancetype)actionGroupWithTitle:(NSString *)title style:(UIPreviewActionStyle)style actions:(NSArray<BAPreviewAction *> *)actions;

@end
