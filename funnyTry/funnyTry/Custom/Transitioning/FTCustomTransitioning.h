//
//  FTCustomTransitioning.h
//  funnyTry
//
//  Created by SGQ on 2017/12/4.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,FTCustomTransitioningType) {
    FTCustomTransitioningCircleMagnify, // 圆形放大
    FTCustomTransitioningCircleShrink,  // 圆形缩小
    FTCustomTransitioningFade,    // 淡入淡出
    FTCustomTransitioningCube,    // 立方体翻转
    FTCustomTransitioningMoveIn,  // 慢慢进入并覆盖效果
    FTCustomTransitioningPush,    // 推进效果
    FTCustomTransitioningReveal,  // 揭开效果
    FTCustomTransitioningOgFlip,        // 翻转
    FTCustomTransitioningSuckEffect,    // 像被吸入瓶子的效果
    FTCustomTransitioningRippleEffect,  // 波纹效果,
    FTCustomTransitioningPageCurl,      // 翻页效果
    FTCustomTransitioningPageUnCurl,    // 反翻页效果
    FTCustomTransitioningCameraIrisHollowOpen,    // 开镜头效果
    FTCustomTransitioningCameraIrisHollowClose,    // 关镜头效果
    
};

@protocol FTCustomTransitioning <NSObject>
@optional
- (CGRect)circleAnimationStartRect;
@end


@interface FTCustomTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

/**
 * actionType: @"present",@"dismiss"
 */
+ (instancetype)transitioningWithType:(FTCustomTransitioningType)type actionType:(NSString*)actionType;

@end
