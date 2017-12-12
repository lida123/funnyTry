//
//  FTCustomInteractiveTransitioning.h
//  funnyTry
//
//  Created by SGQ on 2017/12/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,FTCustomInteractiveTransitioningType) {
    FTCustomInteractiveTransitioningTypePush,
    FTCustomInteractiveTransitioningTypePop,
    FTCustomInteractiveTransitioningTypePresent,
    FTCustomInteractiveTransitioningTypeDismsiss,
};

@interface FTCustomInteractiveTransitioning : UIPercentDrivenInteractiveTransition

@property (nonatomic, copy) void (^PushBlock)(void);
@property (nonatomic, copy) void (^PresentBlock)(void);

+ (instancetype)interactiveTransitioningWithType:(FTCustomInteractiveTransitioningType)type;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
