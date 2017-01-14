//
//  BAConfig.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "BAConfig.h"

CGFloat const BACornerRadius = 10.0f;

CGFloat const BABlurRadius = 5.0f;

CGFloat const BAHorizontalMarginPortrait = 10.0f;

CGFloat const BAVerticalMarginPortrait = 30.0f;

CGFloat const BAHorizontalMarginLandscape = 10.0f;

CGFloat const BAVerticalMarginLandscape = 30.0f;

CGFloat const BAActionItemHeight = 44.0f;

CGFloat const BAActionCollectionViewVerticalMargin = 15.0f;

CGFloat const BAPeekOffset = 10.0f;

CGFloat getHorizontalMargin() {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        // code for landscape orientation
        return BAHorizontalMarginLandscape;
    }
    return BAHorizontalMarginPortrait;
}

CGFloat getVerticalMargin() {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        // code for landscape orientation
        return BAVerticalMarginLandscape;
    }
    return BAVerticalMarginPortrait;
}
