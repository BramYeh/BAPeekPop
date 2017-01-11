//
//  BAPeekPop+Private.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "BAPeekPop.h"

@interface BAPeekPop (Private)

- (void)presentPreviewingViewController:(UIViewController *)contentViewController sourcePoint:(CGPoint)sourcePoint;

- (void)dismissPreviewingViewController;

@end


@interface BAPreviewAction ()

@property(nonatomic, assign, readwrite) UIPreviewActionStyle style;

@end


@interface BAPreviewActionGroup ()

@property(nonatomic, assign, readwrite) UIPreviewActionStyle style;
@property(nonatomic, assign, readwrite) NSArray<BAPreviewAction *> * actions;

@end
