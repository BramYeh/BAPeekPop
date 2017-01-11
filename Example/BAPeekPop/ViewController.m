//
//  ViewController.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

#import <BAPeekPop/BAPeekPop.h>
#import "ViewController.h"
#import "CollectionViewCell.h"
#import "PreviewingViewController.h"

@interface ViewController () <UIViewControllerPreviewingDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BAPeekPop *yoPeekPop;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imageArray = [NSMutableArray array];
    
    NSArray *imageNames = @[@"1", @"2", @"3", @"4"];
    [imageNames enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        [self.imageArray addObject:image];
    }];
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10.0f;
        layout.minimumLineSpacing = 10.0f;
        layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView;
    });
    
    [self.view addSubview:self.collectionView];
    
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]]];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // BAPeekPop
    self.yoPeekPop = [[BAPeekPop alloc] initWithTarget:self];
    [self.yoPeekPop registerForPreviewingWithDelegate:self sourceView:self.view];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size = self.view.bounds.size.width / 2.0f - 15.0f;
    return CGSizeMake(size, size);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSUInteger indexImage = indexPath.item % self.imageArray.count;
    UIImage *image = self.imageArray[indexImage];
    if (image) {
        cell.imageView.image = image;
    }
    
    return cell;
}

#pragma mark - UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    CGPoint point = [self.view convertPoint:location toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (!indexPath) {
        return nil;
    }
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (![cell isKindOfClass:[CollectionViewCell class]]) {
        return nil;
    }
    
    CollectionViewCell *collectionCell = (CollectionViewCell *)cell;
    previewingContext.sourceRect = [self.view convertRect:collectionCell.frame fromView:self.collectionView];
    
    // information is valid, prepare PreviewingViewController
    PreviewingViewController *previewingViewController = [[PreviewingViewController alloc] init];
    previewingViewController.image = collectionCell.imageView.image;
    return previewingViewController;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    // do nothing
    NSLog(NSStringFromSelector(_cmd), nil);
}

@end
