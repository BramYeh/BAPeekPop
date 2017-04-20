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


/**
 Make this function available to other files to be able to use the peekpop view in MKAnnotations since annotations cannot detect long tap gestures using BAPeekPop. However, I would strongly recommend not to call this method directly.
 */
@protocol BAPreviewingViewControllerDelegate <NSObject>

/**
 Delegate to notify BAPreviewingViewController dismissed

 @param previewingViewController customize previewing viewcontroller which is BAPreviewingViewController
 */
- (void)previewingViewControllerDidDismiss:(BAPreviewingViewController *)previewingViewController;

@end


/**
 Make this function available to other files to be able to use the peekpop view in MKAnnotations since annotations cannot detect long tap gestures using BAPeekPop. However, I would strongly recommend not to call this method directly.
 */
@interface BAPreviewingViewController : UIViewController

@property (nonatomic, readonly) BOOL isActionBottonDisplayed;
@property (nonatomic, weak) id <BAPreviewingViewControllerDelegate> delegate;

/**
 Make this function available to other files to be able to use the peekpop view in MKAnnotations since annotations cannot detect long tap gestures using BAPeekPop. However, I would strongly recommend not to call this method directly.

 @param peekViewController <#peekViewController description#>
 @param previewing <#previewing description#>
 @param sourcePoint <#sourcePoint description#>
 @return <#return value description#>
 */
- (instancetype)initWithPeekViewController:(UIViewController *)peekViewController context:(id <UIViewControllerPreviewing>)previewing sourcePoint:(CGPoint)sourcePoint;

/**
 detect this method is used for

 @param point <#point description#>
 @return <#return value description#>
 */
- (BOOL)isTouchPointInView:(CGPoint)point;
/**
 Gesturer detects that user starts peeking
 */
- (void)startPeek;
/**
 <#Description#>

 @param offset <#offset description#>
 */
- (void)handlePeekWithOffset:(CGVector)offset;
/**
 Gesturer detects that user stops peeking
 */
- (void)stopPeek;

@end
