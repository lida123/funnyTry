//
//  FTWaterfallLayout.m
//  funnyTry
//
//  Created by SGQ on 2018/3/8.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTWaterfallLayout.h"

/* 默认边距 */
static const UIEdgeInsets FTDefaultEdgeInsets = {10,10,10,10};
/* 默认列数 */
static const NSUInteger FTDefaultColumnCount = 3;
/* 默认行间距 */
static const CGFloat FTDefaultRowMargin = 10;
/* 默认列间距 */
static const CGFloat FTDefaultColumnMargin = 10;

@interface FTWaterfallLayout ()
@property (nonatomic, strong) NSMutableArray *columnMaxYArray;
@property (nonatomic, strong) NSMutableArray *layoutAttributesArray;
@end

@implementation FTWaterfallLayout

- (void)prepareLayout
{
    // super do nothing
    [super prepareLayout];
    
    NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    // remove old value & add initialization
    [self.columnMaxYArray removeAllObjects];
    for (NSInteger i = 0; i < [self columnCount]; i++) {
        [self.columnMaxYArray addObject:@([self edgeInsets].top)];
    }
    
    // computer all attributes
    [self.layoutAttributesArray removeAllObjects];
    for (NSInteger i = 0; i < itemCount; i++) {
        UICollectionViewLayoutAttributes *attri = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.layoutAttributesArray addObject:attri];
    }
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets edgeInsets = [self edgeInsets];
    NSUInteger columnCount = [self columnCount];
    CGFloat rowMargin = [self rowMargin];
    CGFloat columnMargin = [self columnMargin];
    
    CGFloat width = (CGRectGetWidth(self.collectionView.bounds) - edgeInsets.left - edgeInsets.right - (columnCount - 1)*columnMargin)/(columnCount * 1.0);
    CGFloat height = [self.delegate waterfallLayout:self heightForItemAtIndexPath:indexPath itemWidth:width];
    
    // find out minimum column
    CGFloat destColumnY = [self.columnMaxYArray[0] floatValue];
    NSUInteger destIndex = 0;
    for (NSInteger i = 1; i < columnCount; i++) {
        CGFloat columnY = [self.columnMaxYArray[i] floatValue];
        if (destColumnY > columnY) {
            destColumnY = columnY;
            destIndex = i;
        }
    }
    
    // first line don't need add rowMargin
    CGFloat y = destColumnY + rowMargin;
    if (destColumnY == [self edgeInsets].top) {
        y = destColumnY;
    }
    CGFloat x = edgeInsets.left + (width + columnMargin)*destIndex;

    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.frame = CGRectMake(x, y, width, height);
    
    // update minimum column height
    self.columnMaxYArray[destIndex] = @(CGRectGetMaxY(attri.frame));
    
    return attri;
}

- (CGSize)collectionViewContentSize {
    if (!self.columnMaxYArray.count) {
        return CGSizeZero;
    }
    
    // find out maximum column
    CGFloat destHieght = [self.columnMaxYArray[0] floatValue];
    for (NSInteger i = 1; i < self.columnMaxYArray.count; i++) {
        CGFloat columnMaxY = [self.columnMaxYArray[i] floatValue];
        if (columnMaxY > destHieght) {
            destHieght = columnMaxY;
        }
    }

    return CGSizeMake(0, destHieght + [self edgeInsets].bottom);
}

- (UIEdgeInsets)edgeInsets
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(edgeInsetsInWaterfallLayout:)]) {
        return [self.delegate edgeInsetsInWaterfallLayout:self];
    }
    
    return FTDefaultEdgeInsets;
}

- (NSUInteger)columnCount
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnCountInWaterfallLayout:)]) {
        return [self.delegate columnCountInWaterfallLayout:self];
    }
    
    return FTDefaultColumnCount;
}

- (CGFloat)rowMargin
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rowMarginInWaterfallLayout:)]) {
      return [self.delegate rowMarginInWaterfallLayout:self];
    }
    
    return FTDefaultRowMargin;
}

- (CGFloat)columnMargin
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnCountInWaterfallLayout:)]) {
        return [self.delegate columnMarginInWaterfallLayout:self];
    }
    
    return FTDefaultColumnMargin;
}

#pragma mark -lazy initialize
- (NSMutableArray *)layoutAttributesArray
{
    if (!_layoutAttributesArray) {
        _layoutAttributesArray = [NSMutableArray array];
    }
    return _layoutAttributesArray;
}

- (NSMutableArray *)columnMaxYArray
{
    if (!_columnMaxYArray) {
        _columnMaxYArray = [NSMutableArray array];
    }
    return _columnMaxYArray;
}

@end
