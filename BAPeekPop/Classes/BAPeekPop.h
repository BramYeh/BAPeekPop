//
//  BAPeekPop.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPeekPop : NSObject

- (instancetype)initWithTarget:(UIViewController *)targetController NS_DESIGNATED_INITIALIZER;

- (id <UIViewControllerPreviewing>)registerForPreviewingWithDelegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView;

- (void)unregisterForPreviewingWithContext:(id <UIViewControllerPreviewing>)previewing;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewAction : UIPreviewAction

@property(nonatomic, assign, readonly) UIPreviewActionStyle style;

+ (instancetype)actionWithTitle:(NSString *)title style:(UIPreviewActionStyle)style handler:(void (^)(UIPreviewAction *action, UIViewController *previewViewController))handler;

@end

NS_CLASS_AVAILABLE_IOS(9_0) @interface BAPreviewActionGroup : UIPreviewActionGroup

+ (instancetype)actionGroupWithTitle:(NSString *)title style:(UIPreviewActionStyle)style actions:(NSArray<BAPreviewAction *> *)actions;

@end
