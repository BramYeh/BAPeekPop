//
//  BAActionCollectionViewCell.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "BAActionCollectionViewCell.h"

@interface BAActionCollectionViewCell ()

@end

@implementation BAActionCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupComponent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupComponent];
    }
    return self;
}

- (void)setupComponent {
    _label = ({
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:14.0/255 green:122.0/255 blue:254.0/255 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    [self.contentView addSubview:self.label];

    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                          [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
                                          [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
                                          [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]]];
    
    self.backgroundColor = [UIColor whiteColor];
}

@end
