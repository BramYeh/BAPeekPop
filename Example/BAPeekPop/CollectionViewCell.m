//
//  CollectionViewCell.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import "CollectionViewCell.h"

NSString * const CollectionViewCellIdentifier = @"CollectionViewCell";


@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupComponent];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupComponent];
    }
    return self;
}

- (void)setupComponent {
    self.imageView = ({
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        image.translatesAutoresizingMaskIntoConstraints = NO;
        image.backgroundColor = [UIColor lightGrayColor];
        
        image;
    });
    
    [self.contentView addSubview:self.imageView];
    
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]]];
}

@end
