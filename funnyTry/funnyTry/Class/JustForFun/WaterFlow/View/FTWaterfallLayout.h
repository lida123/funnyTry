//
//  FTWaterfallLayout.h
//  funnyTry
//
//  Created by SGQ on 2018/3/8.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTWaterfallLayout;

@protocol FTWaterfallLayoutDelegate <NSObject>
@required
- (CGFloat)waterfallLayout:(FTWaterfallLayout*)waterfallLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
- (NSUInteger)columnCountInWaterfallLayout:(FTWaterfallLayout*)waterfallLayout;
- (CGFloat)columnMarginInWaterfallLayout:(FTWaterfallLayout *)waterfallLayout;
- (CGFloat)rowMarginInWaterfallLayout:(FTWaterfallLayout *)waterfallLayout;
- (UIEdgeInsets)edgeInsetsInWaterfallLayout:(FTWaterfallLayout *)waterfallLayout;
@end

@interface FTWaterfallLayout : UICollectionViewLayout
@property (nonatomic, weak) id <FTWaterfallLayoutDelegate> delegate;
@end

