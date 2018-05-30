//
//  UIImage+Function.h
//  学习之路
//
//  Created by SGQ on 16/12/7.
//  Copyright © 2016年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Function)

/**
 *  将图片选装任意角度
 *
 *  @param angel 角度(非弧度)
 *
 *  @return 旋转后的新图片
 */
- (UIImage*)newImageWithRotatedAngle:(CGFloat)angel;
// ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑这个方法是辅助上面的方法,(如果是旋转非90度的倍数)为了让图片显示跟设计给的看起来图片一样大,需要将显示图片的imagerV大小修改为该方法返回的大小
- (CGSize)newImageSizeWithRotatedAngle:(CGFloat)angel;

/**
 *  获取图片某点的颜色,点不在图片内返回nil
 *
 *  @param point 点的位置
 *
 *  @return 颜色
 */
- (UIColor*)colorAtPoint:(CGPoint)point;

/** 获得灰度图 */
- (UIImage *)convertToGrayImage;
@end
