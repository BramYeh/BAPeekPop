//
//  BAPeekPop+Private.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "BAPeekPop.h"

@interface BAPeekPop (Private)

/// The current top view controller of the application
@property (nonatomic, readonly) UIViewController *topmostViewController;

@end


@interface BAPreviewAction ()

@property(nonatomic, assign, readwrite) UIPreviewActionStyle style;

@end


@interface BAPreviewActionGroup ()

@property(nonatomic, assign, readwrite) UIPreviewActionStyle style;
@property(nonatomic, assign, readwrite) NSArray<BAPreviewAction *> * actions;

@end
