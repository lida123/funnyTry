//
//  FTCustomInteractiveTransitioning.m
//  funnyTry
//
//  Created by SGQ on 2017/12/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomInteractiveTransitioning.h"

@interface FTCustomInteractiveTransitioning()
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) FTCustomInteractiveTransitioningType type;
@end

@implementation FTCustomInteractiveTransitioning

- (instancetype)initWithType:(FTCustomInteractiveTransitioningType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

+ (instancetype)interactiveTransitioningWithType:(FTCustomInteractiveTransitioningType)type {
    return [[self alloc] initWithType:type];
}

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:panGesture];
}

- (void)handleGesture:(UIPanGestureRecognizer*)panGesture {
    //手势百分比
    CGFloat percent = 0;
    switch (self.type) {
        case FTCustomInteractiveTransitioningTypePush: {
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
            
        case FTCustomInteractiveTransitioningTypePop:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            percent = transitionX / panGesture.view.frame.size.width;
        }
            break;
            
        case FTCustomInteractiveTransitioningTypePresent:
            
            break;
            
        case FTCustomInteractiveTransitioningTypeDismsiss:
            
            break;
    }
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        //手势开始的时候标记手势状态，并开始相应的事件
        self.interation = YES;
        [self startGesture];
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        [self updateInteractiveTransition:percent];
    
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作

        // 获取手指离开时候的速度
        CGFloat velocityX = [panGesture velocityInView:panGesture.view].x;
        CGPoint translation = [panGesture translationInView:panGesture.view];
        // 这里的targetX是根据scrollView松手时候猜想的，这个可以动态的稍微调整一下。
        CGFloat tempTargetX = (translation.x + velocityX * 0.2);
        CGFloat gestureTargetX = (tempTargetX + translation.x) / 2;
        if (self.type == FTCustomInteractiveTransitioningTypePush) {
            gestureTargetX = -gestureTargetX;
            gestureTargetX = MIN(gestureTargetX, panGesture.view.bounds.size.width);
        }else {
            
        }
        percent = gestureTargetX / panGesture.view.frame.size.width;
        
        self.interation = NO;
        if (percent > 0.5) {
            [self finishInteractiveTransition];
        }else{
            [self cancelInteractiveTransition];
        }
    }
    NSLog(@"%f",percent);
}

- (void)startGesture{
    switch (self.type) {
        case FTCustomInteractiveTransitioningTypePush:
            self.PushBlock();
            break;
            
        case FTCustomInteractiveTransitioningTypePop:
            [_vc.navigationController popViewControllerAnimated:YES]
            ;
            break;
            
        case FTCustomInteractiveTransitioningTypePresent:
            self.PresentBlock();
            break;
            
        case FTCustomInteractiveTransitioningTypeDismsiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

@end
