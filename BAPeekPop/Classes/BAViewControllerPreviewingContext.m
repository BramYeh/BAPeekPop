//
//  BAViewControllerPreviewing.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "BAViewControllerPreviewingContext.h"

@interface BAViewControllerPreviewingContext ()

@property (nonatomic, strong) UIGestureRecognizer *previewingGestureRecognizerForFailureRelationship;
@property (nonatomic, strong) id<UIViewControllerPreviewingDelegate> delegate;
@property (nonatomic, strong) UIView *sourceView;

@end


@implementation BAViewControllerPreviewingContext

- (instancetype)initWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer delegate:(id<UIViewControllerPreviewingDelegate>)delegate sourceView:(UIView *)sourceView {
    self = [super init];
    if (self) {
        self.previewingGestureRecognizerForFailureRelationship = gestureRecognizer;
        self.delegate = delegate;
        self.sourceView = sourceView;
        // the default value of this property corresponds to the bounds of the view in the sourceView property
        self.sourceRect = sourceView.bounds;
    }
    return self;
}

@end
