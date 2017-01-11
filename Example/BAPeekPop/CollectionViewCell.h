//
//  CollectionViewCell.h
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CollectionViewCellIdentifier;

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *imageView;

@end
