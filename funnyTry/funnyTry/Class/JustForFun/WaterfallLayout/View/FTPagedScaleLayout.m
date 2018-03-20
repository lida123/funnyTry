//
//  FTPagedScaleLayout.m
//  funnyTry
//
//  Created by SGQ on 2018/3/12.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTPagedScaleLayout.h"

@implementation FTPagedScaleLayout

- (instancetype)init
{
    if (self = [super init]) {
        _centerScale = 1.0f;
        _nearbyScale = 0.8f;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];

    CGFloat left = (self.collectionView.bounds.size.width - self.itemSize.width) / 2.0;
    self.sectionInset = UIEdgeInsetsMake(0, left, 0, left);

    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // The closer, the bigger
    NSArray *attributes = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
    CGFloat currentCenterX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
    for (UICollectionViewLayoutAttributes *attri in attributes) {
        CGFloat itemCenterX = attri.center.x;
        CGFloat delta = ABS(currentCenterX - itemCenterX);
        delta = MIN(delta, self.collectionView.bounds.size.width);
        CGFloat scale = (self.nearbyScale - self.centerScale) * delta / self.collectionView.bounds.size.width + self.centerScale;
        attri.transform = CGAffineTransformMakeScale(1, scale);
    }

    return attributes;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{    
    // final rect
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    // find nearest item
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;;
    CGFloat targetOffSetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (ABS(targetOffSetX) > ABS(centerX - attribute.center.x)) {
            targetOffSetX = attribute.center.x - centerX;
        }
    }

   return CGPointMake(proposedContentOffset.x + targetOffSetX, proposedContentOffset.y);
}

//  UICollectionViewFlowLayout has cached frame mismatch for index path这个警告来源主要是在使用layoutAttributesForElementsInRect：方法返回的数组时，没有使用该数组的拷贝对象，而是直接使用了该数组。解决办法对该数组进行拷贝，并且是深拷贝。

- (NSArray *)deepCopyWithArray:(NSArray *)arr {
    NSMutableArray *arrM = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in arr) {
        [arrM addObject:[attr copy]];
    }
    return arrM;
}

#pragma mark -判断该indexPath是否处于中间位置
- (BOOL)isItemInTheMiddle:(NSIndexPath *)indexPath
{
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = self.collectionView.contentOffset.x;
    rect.size = self.collectionView.frame.size;
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;;
    NSIndexPath *centerIndexPath = nil;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.center.x == centerX) {
            centerIndexPath = attribute.indexPath;
            break;
        }
    }
    
    return ([indexPath compare:centerIndexPath] == NSOrderedSame);
}

@end
