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
 call only when BAPreviewingViewController dismissed

 @param previewingViewController dimissed view controller of BAPreviewingViewController
 */
- (void)previewingViewControllerDidDismiss:(BAPreviewingViewController *)previewingViewController;

@end

/**
 Make this function available to other files to be able to use the peekpop view in MKAnnotations since annotations cannot detect long tap gestures using BAPeekPop. However, I would strongly recommend not to call this method directly.
 */
@interface BAPreviewingViewController : UIViewController

/**
 it should be detected by action buttons displaying or not
 */
@property (nonatomic, assign) BOOL isActionBottonDisplayed;
/**
 it's delegation of BAPreviewingViewControllerDelegate
 */
@property (nonatomic, weak) id <BAPreviewingViewControllerDelegate> delegate;

@end
