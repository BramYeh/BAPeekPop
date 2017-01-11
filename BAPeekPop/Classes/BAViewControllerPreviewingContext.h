//
//  BAViewControllerPreviewing.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BAViewControllerPreviewingContext : NSObject <UIViewControllerPreviewing>

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer delegate:(id<UIViewControllerPreviewingDelegate>) delegate sourceView:(UIView *)sourceView;

@property (nonatomic, assign) CGRect sourceRect;

@end
