//
//  FTPagedScaleLayout.h
//  funnyTry
//
//  Created by SGQ on 2018/3/12.
//  Copyright © 2018年 GQ. All rights reserved.
//  适用于一页一个item,中间的最大,旁边次之(仿优酷精选播单,在VIP会员界面)

#import <UIKit/UIKit.h>

@interface FTPagedScaleLayout : UICollectionViewFlowLayout

/**
 * 最中间的item scale, default:1.0f
 */
@property (nonatomic, assign) CGFloat centerScale;

/**
 * 最中间旁边的item scale, default:0.8f
 */
@property (nonatomic, assign) CGFloat nearbyScale;

// send scrollView event here
- (void)scrollViewWillBeginDragging;

/**
 * 判断该indexPath是否处于中间位置(一般来说,点击中间的item会push到下级界面,而点击两侧的item,会将item滚到中间)
 */
- (BOOL)isItemInTheMiddle:(NSIndexPath *)indexPath;

@end
