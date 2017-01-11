//
//  BAPreviewingViewController.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BAPreviewingViewController;


@protocol BAPreviewingViewControllerDelegate <NSObject>

- (void)previewingViewControllerDidDismiss:(BAPreviewingViewController *)previewingViewController;

@end


@interface BAPreviewingViewController : UIViewController

@property (nonatomic, readonly) BOOL isActionBottonDisplayed;
@property (nonatomic, weak) id <BAPreviewingViewControllerDelegate> delegate;

- (instancetype)initWithPeekViewController:(UIViewController *)peekViewController context:(id <UIViewControllerPreviewing>)previewing sourcePoint:(CGPoint)sourcePoint;

- (BOOL)isTouchPointInView:(CGPoint)point;
- (void)startPeek;
- (void)handlePeekWithOffset:(CGVector)offset;
- (void)stopPeek;

@end
