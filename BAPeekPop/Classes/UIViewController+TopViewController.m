//
//  UIViewController+TopViewController.m
//  Pods
//
//  Created by gabmarfer on 05/05/2017.
//
//
//  Gist from https://gist.github.com/snikch/3661188

#import "UIViewController+TopViewController.h"

@implementation UIViewController (TopViewController)

- (UIViewController *)ba_topmostViewController {
    return [self p_topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)p_topViewController:(UIViewController *)rootViewController {
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self p_topViewController:[navigationController.viewControllers lastObject]];
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self p_topViewController:tabController.selectedViewController];
    }
    
    if (rootViewController.presentedViewController) {
        return [self p_topViewController:rootViewController];
    }
    
    return rootViewController;
}

@end
