//
//  BAPreviewingViewController+Private.h
//  Pods
//
//  Created by  Bram Yeh on 2017/4/20.
//
//

#import "BAPreviewingViewController.h"

@class BAPreviewingViewController;


@protocol BAPreviewingViewControllerDelegate <NSObject>

- (void)previewingViewControllerDidDismiss:(BAPreviewingViewController *)previewingViewController;

@end


@interface BAPreviewingViewController (Private)

@property (nonatomic, readonly) BOOL isActionBottonDisplayed;
@property (nonatomic, weak) id <BAPreviewingViewControllerDelegate> delegate;

- (instancetype)initWithPeekViewController:(UIViewController *)peekViewController context:(id <UIViewControllerPreviewing>)previewing sourcePoint:(CGPoint)sourcePoint;

- (BOOL)isTouchPointInView:(CGPoint)point;

- (void)startPeek;

- (void)handlePeekWithOffset:(CGVector)offset;

- (void)stopPeek;

@end
