//
//  UIButton+CircleLoading.h
//  funnyTry
//
//  Created by SGQ on 2017/11/16.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCircleLoadingView.h"

@interface UIButton (CircleLoading)

@property (nonatomic, strong) FTCircleLoadingView *cl_loadingView;

/**
 * 圆圈和对勾的颜色
 */
- (void)cl_setLayerColor:(UIColor *)layerColor;

/**
 * 圆圈和对勾的颜色
 */
- (void)cl_setLayerWidth:(CGFloat) layerWidth;

/**
 * 开始转起来
 */
- (void)cl_startLoading;

/**
 * 对勾动画
 */
- (void)cl_endLoadingSucceedWithEndBlock:(void (^)(void))endBlock;

@end
