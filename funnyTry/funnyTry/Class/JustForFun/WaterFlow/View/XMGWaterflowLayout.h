//
//  AppDelegate.h
//  funnyTry
//
//  Created by SGQ on 2017/10/31.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGWaterflowLayout;

@protocol XMGWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(XMGWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout;
@end

@interface XMGWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<XMGWaterflowLayoutDelegate> delegate;
@end
