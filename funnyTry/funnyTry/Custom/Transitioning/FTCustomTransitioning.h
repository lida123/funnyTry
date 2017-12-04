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
    
};

@protocol FTCustomTransitioning <NSObject>
@optional
- (CGRect)circleAnimationStartRect;
@end


@interface FTCustomTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitioningWithType:(FTCustomTransitioningType)type;

@end
