//
//  PreviewingViewController.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import <BAPeekPop/BAPeekPop.h>
#import "PreviewingViewController.h"

@interface PreviewingViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PreviewingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView = ({
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        image.translatesAutoresizingMaskIntoConstraints = NO;
        image.backgroundColor = [UIColor lightGrayColor];
        
        image;
    });
    
    [self.view addSubview:self.imageView];
    
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.image) {
        self.imageView.image = self.image;
    }
}

- (CGSize)preferredContentSize {
    return self.image.size;
}

#pragma mark - UIPreviewActionItem

- (NSArray <id <UIPreviewActionItem>> *)previewActionItems {
    BAPreviewAction *actionStyleDefault = [BAPreviewAction actionWithTitle:@"UIPreviewActionStyleDefault" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"UIPreviewAction with UIPreviewActionStyleDefault");
    }];
    
    BAPreviewActionGroup *actionGoup = [BAPreviewActionGroup actionGroupWithTitle:@"UIPreviewActionGroup" style:UIPreviewActionStyleDefault actions:@[[BAPreviewAction actionWithTitle:@"ActionGroup with 1st position" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
    }],
                                                                                                                                                      [BAPreviewAction actionWithTitle:@"ActionGroup with 2nd position" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
    }],
                                                                                                                                                      [BAPreviewAction actionWithTitle:@"ActionGroup with 3rd position" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
    }]
                                                                                                                                                      ]];
    
    BAPreviewAction *actionStyleDestructive = [BAPreviewAction actionWithTitle:@"UIPreviewActionStyleDestructive" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"UIPreviewAction with UIPreviewActionStyleDestructive");
    }];
    
    return @[actionStyleDefault, actionStyleDefault, actionStyleDefault, actionStyleDefault, actionStyleDefault, actionStyleDefault, actionStyleDefault, actionStyleDefault, actionStyleDefault, actionGoup, actionStyleDestructive];
}

@end
