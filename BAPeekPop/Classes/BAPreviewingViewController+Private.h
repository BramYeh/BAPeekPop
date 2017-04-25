//
//  BAPreviewingViewController+Private.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "BAPreviewingViewController.h"




@interface BAPreviewingViewController (Private)

- (instancetype)initWithPeekViewController:(UIViewController *)peekViewController context:(id <UIViewControllerPreviewing>)previewing sourcePoint:(CGPoint)sourcePoint;

- (BOOL)isTouchPointInView:(CGPoint)point;

- (void)startPeek;

- (void)handlePeekWithOffset:(CGVector)offset;

- (void)stopPeek;

@end
