//
//  BAPreviewingViewController.m
//  BAPeekPop
//
//  Created by Bram (hryeh) on 01/11/2017.
//  Copyright (c) 2017 Bram (hryeh). All rights reserved.
//

@import Accelerate;

#import "BAPeekPop+Private.h"
#import "BAPreviewingViewController+Private.h"
#import "BAConfig.h"
#import "BAActionCollectionViewCell.h"

@interface BAPreviewingViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGPoint sourcePoint;
@property (nonatomic, strong) UIImageView *blurBackgroundImageView;
@property (nonatomic, strong) UIImageView *arrowUpImageView;
@property (nonatomic, weak) UIViewController *peekViewController;
@property (nonatomic, weak) id <UIViewControllerPreviewing> previewing;
// drag offset parameter
@property (nonatomic, assign) CGRect startedPeekFrame;
// action items
@property (nonatomic, strong) UICollectionView *actionCollectionView;
@property (nonatomic, copy) NSArray <id <UIPreviewActionItem>> *actionItems;
// original view's setting temp cache
@property(nullable, strong) CALayer *origViewLayerMask;

@end

@implementation BAPreviewingViewController

- (instancetype)initWithPeekViewController:(UIViewController *)peekViewController context:(id <UIViewControllerPreviewing>)previewing sourcePoint:(CGPoint)sourcePoint {
    self = [super init];
    if (self) {
        self.peekViewController = peekViewController;
        self.previewing = previewing;
        self.sourcePoint = sourcePoint;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // set blur background image
    self.blurBackgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.blurBackgroundImageView.image = [self blurBackgroundImage];
    self.blurBackgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.blurBackgroundImageView];
    
    [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.blurBackgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.blurBackgroundImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.blurBackgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f],
                                              [NSLayoutConstraint constraintWithItem:self.blurBackgroundImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]]];

    // Initialization
    self.actionItems = [self.peekViewController previewActionItems];
    if (self.actionItems.count > 0) {
        // 1. add actions items
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewLayout.minimumLineSpacing = 1.0f / [UIScreen mainScreen].scale;
        collectionViewLayout.minimumInteritemSpacing = 0.0f;
        collectionViewLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - getHorizontalMargin() * 2, BAActionItemHeight);
        
        CGSize preferSize = [self preferFrameOfActionCollectionView].size;
        CGRect initActionFrame = CGRectMake(([UIScreen mainScreen].bounds.size.width - preferSize.width) / 2.0f,
                                            [UIScreen mainScreen].bounds.size.height,
                                            preferSize.width,
                                            preferSize.height);
        
        self.actionCollectionView = ({
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:initActionFrame collectionViewLayout:collectionViewLayout];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.bounces = NO;
            collectionView.backgroundColor = [UIColor lightGrayColor];
            collectionView.layer.cornerRadius = BACornerRadius;
            collectionView.layer.masksToBounds = YES;
            [collectionView registerClass:[BAActionCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BAActionCollectionViewCell class])];
            collectionView;
        });
        
        [self.view addSubview:self.actionCollectionView];
        
        // 2. add arrow-up icon
        self.arrowUpImageView = ({
            UIImage *image = [UIImage imageNamed:@"icon-arrow-up" inBundle:[NSBundle bundleForClass:[BAPreviewingViewController class]] compatibleWithTraitCollection:nil];
            UIImageView *arrowUpImageView = [[UIImageView alloc] initWithImage:image];
            arrowUpImageView.translatesAutoresizingMaskIntoConstraints = NO;
            arrowUpImageView.alpha = 0.0f;
            arrowUpImageView;
        });
        
        [self.view addSubview:self.arrowUpImageView];
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if (!parent) {
        [self.peekViewController willMoveToParentViewController:nil];
        
        // 1. remove arrowUpImageView's layout constraint
        if (self.arrowUpImageView) {
            [self.arrowUpImageView removeConstraints:self.arrowUpImageView.constraints];
        }
        
        // 2. remove peekViewController
        self.peekViewController.view.layer.mask = self.origViewLayerMask;
        [self.peekViewController.view removeFromSuperview];
        [self.peekViewController removeFromParentViewController];
    }
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    if (parent) {
        // 1. add peekViewController into view hierarchy
        [self addChildViewController:self.peekViewController];
        self.origViewLayerMask = self.peekViewController.view.layer.mask;
        self.peekViewController.view.layer.mask = ({
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.peekViewController.view.bounds
                                                           byRoundingCorners:UIRectCornerAllCorners
                                                                 cornerRadii:CGSizeMake(BACornerRadius, BACornerRadius)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.peekViewController.view.bounds;
            maskLayer.path = maskPath.CGPath;
            
            maskLayer;
        });
        [self.view addSubview:self.peekViewController.view];
        
        self.peekViewController.view.frame = [self defaultFrameOfPreviewingController];
        // animation enter
        self.peekViewController.view.alpha = 0.0f;
        self.peekViewController.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(self.sourcePoint.x - CGRectGetMidX(self.peekViewController.view.frame),
                                                                                                         self.sourcePoint.y - CGRectGetMidY(self.peekViewController.view.frame)), 0.3f, 0.3f);
        [UIView animateWithDuration:0.3f animations:^{
            self.arrowUpImageView.alpha = 1.0f;
            self.peekViewController.view.alpha = 1.0f;
            self.peekViewController.view.transform = CGAffineTransformIdentity;
        }];
        
        [self.peekViewController didMoveToParentViewController:self];
        
        // 2. locate action buttons
        CGSize preferSize = [self preferFrameOfActionCollectionView].size;
        self.actionCollectionView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - preferSize.width) / 2.0f,
                                                     [UIScreen mainScreen].bounds.size.height,
                                                     preferSize.width,
                                                     preferSize.height);
        
        // 3. locate arrowUpImageView's layout constraint
        if (self.arrowUpImageView) {
            [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:self.arrowUpImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.peekViewController.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:-10.0f],
                                                      [NSLayoutConstraint constraintWithItem:self.arrowUpImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.peekViewController.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]];
        }
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    // should animate previewing view and then callback function
    if ([self.delegate respondsToSelector:@selector(previewingViewControllerDidDismiss:)]) {
        [self.delegate previewingViewControllerDidDismiss:self];
    }
}

- (CGRect)defaultFrameOfPreviewingController {
    // TODO, need to survey iOS's default 3D touch previewing rect
    CGRect defaultFrame = CGRectInset([UIScreen mainScreen].bounds, getHorizontalMargin(), getVerticalMargin());
    CGSize preferredContentSize = self.peekViewController.preferredContentSize;
    
    // invalid preferredContentSize, return default frame
    if (preferredContentSize.width <= 0.0f || preferredContentSize.height <= 0.0f) {
        return defaultFrame;
    }
    
    CGFloat ratio = preferredContentSize.height / preferredContentSize.width;
    if (defaultFrame.size.width < preferredContentSize.width) {
        preferredContentSize.width = defaultFrame.size.width;
        preferredContentSize.height = defaultFrame.size.width * ratio;
    }
    if (defaultFrame.size.height < preferredContentSize.height) {
        preferredContentSize.height = defaultFrame.size.height;
        preferredContentSize.width = defaultFrame.size.height / ratio;
    }
    
    return CGRectMake(([UIScreen mainScreen].bounds.size.width - preferredContentSize.width) / 2.0f,
                      ([UIScreen mainScreen].bounds.size.height - preferredContentSize.height) / 2.0f,
                      preferredContentSize.width,
                      preferredContentSize.height);
}

- (CGRect)preferFrameOfActionCollectionView {
    // TODO, need to survey iOS's default 3D touch previewing rect
    CGFloat height = MIN(self.actionCollectionView.contentSize.height, [UIScreen mainScreen].bounds.size.height * 0.65f);
    if (self.actionCollectionView.contentSize.height <= 0) {
        height = [UIScreen mainScreen].bounds.size.height * 0.65f; // default height
    }
    
    CGSize preferSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - getHorizontalMargin() * 2, height);
    
    return CGRectMake(([UIScreen mainScreen].bounds.size.width - preferSize.width) / 2.0f,
                      [UIScreen mainScreen].bounds.size.height - preferSize.height - BAActionCollectionViewVerticalMargin,
                      preferSize.width,
                      preferSize.height);
}

#pragma mark - Gesture Handling

- (BOOL)isTouchPointInView:(CGPoint)point {
    return CGRectContainsPoint(self.peekViewController.view.frame, point);
}

- (void)startPeek {
    self.startedPeekFrame = self.peekViewController.view.frame;
}

- (void)handlePeekWithOffset:(CGVector)offset {
    self.peekViewController.view.frame = CGRectOffset(self.startedPeekFrame, 0.0f, offset.dy * 0.5f);
    
    if (!self.actionCollectionView) {
        return;
    }
    
    CGRect preferFrameOfActionCollectionView = [self preferFrameOfActionCollectionView];
    if (offset.dy <= -BAPeekOffset && !CGRectIntersectsRect(self.view.frame, self.actionCollectionView.frame)) {
        // case: drag upward and need to display action buttons
        // animation bottom sheet for collection view
        self.isActionBottonDisplayed = YES;
        
        CGRect targetRect = preferFrameOfActionCollectionView;
        if (CGRectGetMinY(targetRect) < CGRectGetMaxY(self.peekViewController.view.frame) + BAActionCollectionViewVerticalMargin) {
            targetRect.origin.y = CGRectGetMaxY(self.peekViewController.view.frame) + BAActionCollectionViewVerticalMargin;
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            self.actionCollectionView.frame = targetRect;
            self.arrowUpImageView.alpha = 0.0f;
        }];
        
    } else if (offset.dy >= BAPeekOffset && CGRectIntersectsRect(self.view.frame, self.actionCollectionView.frame)) {
        // case: drag downward and need to hide action buttons
        self.isActionBottonDisplayed = NO;
        
        CGSize preferSize = preferFrameOfActionCollectionView.size;
        CGRect targetRect = CGRectMake(([UIScreen mainScreen].bounds.size.width - preferSize.width) / 2.0f,
                                       [UIScreen mainScreen].bounds.size.height,
                                       preferSize.width,
                                       preferSize.height);
        
        [UIView animateWithDuration:0.2f animations:^{
            self.actionCollectionView.frame = targetRect;
            self.arrowUpImageView.alpha = 1.0f;
        }];
        
    } else if (CGRectGetMinY(self.actionCollectionView.frame) > CGRectGetMinY(preferFrameOfActionCollectionView) && self.isActionBottonDisplayed /*CGRectIntersectsRect(self.view.frame, self.collectionView.frame)*/) {
        // case: action buttons are a lots, so that collectionve didn't display all
        CGRect targetRect = preferFrameOfActionCollectionView;
        if (CGRectGetMinY(targetRect) < CGRectGetMaxY(self.peekViewController.view.frame) + BAActionCollectionViewVerticalMargin) {
            targetRect.origin.y = CGRectGetMaxY(self.peekViewController.view.frame) + BAActionCollectionViewVerticalMargin;
        }
        self.actionCollectionView.frame = targetRect;
    }
}

- (void)stopPeek {
    CGRect preferFrameOfActionCollectionView = [self preferFrameOfActionCollectionView];

    if (self.isActionBottonDisplayed) {
        // needn't dismiss, keep display previewing
        CGFloat topPeekView = CGRectGetMinY(preferFrameOfActionCollectionView) - BAActionCollectionViewVerticalMargin - CGRectGetHeight(self.peekViewController.view.frame);
        CGRect rectPeekView = [self defaultFrameOfPreviewingController];
        rectPeekView.origin.y = MIN(topPeekView, rectPeekView.origin.y);
        
        [UIView animateWithDuration:0.2f animations:^{
            self.peekViewController.view.frame = rectPeekView;
            self.actionCollectionView.frame = preferFrameOfActionCollectionView;
        }];
        
    } else {
        CGAffineTransform destTransform = CGAffineTransformScale(CGAffineTransformMakeTranslation(self.sourcePoint.x - CGRectGetMidX(self.peekViewController.view.frame),
                                                                                                  self.sourcePoint.y - CGRectGetMidY(self.peekViewController.view.frame)), 0.3f, 0.3f);
        self.peekViewController.view.alpha = 1.0f;
        self.peekViewController.view.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:0.3f animations:^{
            self.peekViewController.view.alpha = 0.0f;
            self.peekViewController.view.transform = destTransform;
            self.actionCollectionView.transform = CGAffineTransformMakeTranslation(0.0f, [UIScreen mainScreen].bounds.size.height - CGRectGetMinY(self.actionCollectionView.frame));
            self.arrowUpImageView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            // should animate previewing view and then callback function
            if ([self.delegate respondsToSelector:@selector(previewingViewControllerDidDismiss:)]) {
                [self.delegate previewingViewControllerDidDismiss:self];
            }
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actionItems.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BAActionCollectionViewCell *cell = [self.actionCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BAActionCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.item >= self.actionItems.count) {
        return cell;
    }
    
    id <UIPreviewActionItem> actionItem = self.actionItems[indexPath.item];
    cell.label.text = actionItem.title;
    
    // TODO, should custumized by type
    if ([actionItem isKindOfClass:[BAPreviewActionGroup class]]) {
        // ((BAPreviewActionGroup *)actionItem).style;
    } else if ([actionItem isKindOfClass:[BAPreviewAction class]]) {
        // ((BAPreviewAction *)actionItem).style;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout 

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= self.actionItems.count) {
        return;
    }
    
    id <UIPreviewActionItem> actionItem = self.actionItems[indexPath.item];
    
    if ([actionItem isKindOfClass:[BAPreviewActionGroup class]]) {
        BAPreviewActionGroup *yoActionGroup = (BAPreviewActionGroup *)actionItem;
        self.actionItems = yoActionGroup.actions;
        // TODO, it should animation out self.collectionview
        // and then reload data, finally animation pop up self.collectionview
        [UIView animateWithDuration:0.2f animations:^{
            // bottom sheet out of screen
            self.actionCollectionView.frame = CGRectMake(CGRectGetMinX(self.actionCollectionView.frame),
                                                         [UIScreen mainScreen].bounds.size.height,
                                                         CGRectGetWidth(self.actionCollectionView.frame),
                                                         CGRectGetHeight(self.actionCollectionView.frame));
        } completion:^(BOOL finished) {
            [self.actionCollectionView reloadData];
            [self.actionCollectionView performBatchUpdates:^{
                // do nothing, just make sure content size if correct
            } completion:^(BOOL finished) {
                CGRect preferFrameOfActionCollectionView = [self preferFrameOfActionCollectionView];
                CGFloat topPeekView = CGRectGetMinY(preferFrameOfActionCollectionView) - BAActionCollectionViewVerticalMargin - CGRectGetHeight(self.peekViewController.view.frame);
                CGRect rectPeekView = [self defaultFrameOfPreviewingController];
                rectPeekView.origin.y = MIN(topPeekView, rectPeekView.origin.y);
                
                [UIView animateWithDuration:0.2f animations:^{
                    self.peekViewController.view.frame = rectPeekView;
                    self.actionCollectionView.frame = preferFrameOfActionCollectionView;
                }];
            }];
        }];
        
    } else if ([actionItem isKindOfClass:[UIPreviewAction class]]) {
        UIPreviewAction *previewAction = (UIPreviewAction *)actionItem;
        [UIView animateWithDuration:0.2f animations:^{
            self.peekViewController.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, -CGRectGetMaxY(self.peekViewController.view.frame));
            self.actionCollectionView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.0f, CGRectGetMinY(self.actionCollectionView.frame));
            
        } completion:^(BOOL finished) {
            if (previewAction.handler) {
                previewAction.handler(actionItem, self.peekViewController);
            }
            if ([self.delegate respondsToSelector:@selector(previewingViewControllerDidDismiss:)]) {
                [self.delegate previewingViewControllerDidDismiss:self];
            }
        }];
    }
}

#pragma mark - Utils

- (UIImage *)blurBackgroundImage {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // ref:http://stackoverflow.com/questions/20558033/ios-7-taking-screenshot-of-part-of-a-uiview
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *blurBackgroundImage = [self imageBlur:snapshotImage withRadius:BABlurRadius];
    return blurBackgroundImage;
}

- (UIImage *)imageBlur:(UIImage *)image withRadius:(NSInteger)blurRadius {
    CGRect imageDrawRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -image.size.height);
    CGContextDrawImage(effectInContext, imageDrawRect, image.CGImage);
    
    vImage_Buffer effectInBuffer;
    effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
    
    CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
    NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
    if (radius % 2 != 1) {
        radius += 1;
    }
    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -image.size.height);
    
    CGContextDrawImage(outputContext, imageDrawRect, image.CGImage);
    
    CGContextSaveGState(outputContext);
    CGContextDrawImage(outputContext, imageDrawRect, finalImage.CGImage);
    CGContextRestoreGState(outputContext);
    
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
