//
//  UIViewController+TopViewController.h
//  Pods
//
//  Created by gabmarfer on 05/05/2017.
//
//
//  Gist from https://gist.github.com/snikch/3661188

#import <UIKit/UIKit.h>

@interface UIViewController (TopViewController)

/// The current top view controller of the application
@property (nonatomic, readonly) UIViewController *ba_topmostViewController;
@end
