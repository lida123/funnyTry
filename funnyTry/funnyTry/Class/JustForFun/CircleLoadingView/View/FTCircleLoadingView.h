//
//  FTCircleLoadingView.h
//  funnyTry
//
//  Created by SGQ on 2017/11/16.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCircleLoadingView : UIView

//! @abstract 圆圈和对勾的颜色
@property (nonatomic, strong) UIColor *layerColor;

//! @abstract 圆圈和对勾的颜色
@property (nonatomic, assign) CGFloat layerWidth;

//! @abstract 对勾动画结束执行的回调
@property (nonatomic, copy) void (^endBlock)(void);

/**
 * 开始转起来
 */
- (void)startLoading;

/**
 * 对勾动画
 */
- (void)endLoadingSucceed;

@end
