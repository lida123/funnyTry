//
//  FTCustomTransitioning.m
//  funnyTry
//
//  Created by SGQ on 2017/12/4.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomTransitioning.h"

@interface FTCustomTransitioning ()<CAAnimationDelegate>
@property (nonatomic, assign) FTCustomTransitioningType type;
@end

@implementation FTCustomTransitioning

- (instancetype)initWithTransitioningWithType:(FTCustomTransitioningType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

+ (instancetype)transitioningWithType:(FTCustomTransitioningType)type {
    return [[self alloc] initWithTransitioningWithType:type];
}

- (CGFloat)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.55;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_type) {
        case FTCustomTransitioningCircleShrink:
            [self circleShrinkAnimation:transitionContext];
            break;
        case FTCustomTransitioningCircleMagnify:
            [self circleMagnifyAnimation:transitionContext];
            break;
        default:
            break;
    }
}

#pragma mark - 圆形放大
- (void)circleMagnifyAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 起始vc topVC (本项目这个present行为实际上是tabbarController执行的)
    UIViewController<FTCustomTransitioning> *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC = (UIViewController<FTCustomTransitioning> *)[self topViewControllerForController:fromVC];
    CGRect fromRect;
    if ([fromVC respondsToSelector:@selector(circleAnimationStartRect)]) {
        fromRect = [fromVC circleAnimationStartRect];
    }else {
        fromRect = CGRectMake(0, 0, 40, 40);
        fromRect.origin = fromVC.view.center;
    }
    
    // 最终vc
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC = [self topViewControllerForController:toVC];
    
    // 将present的视图添加到container上去
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toVC.view];
    
    //创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    UIBezierPath *fromValue = [UIBezierPath bezierPathWithOvalInRect:fromRect];
    CGFloat x = MAX(fromRect.origin.x, containerView.bounds.size.width - fromRect.origin.x);
    CGFloat y = MAX(fromRect.origin.y, containerView.bounds.size.height - fromRect.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *toValue = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    animation.fromValue = (id)fromValue.CGPath;
    animation.toValue = (id)toValue.CGPath;
    animation.duration = [self transitionDuration:nil];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setValue:transitionContext forKey:@"transitionContext"];
    animation.delegate = self;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = toValue.CGPath;
    [maskLayer addAnimation:animation forKey:@"shrinkAnimation"];
    toVC.view.layer.mask = maskLayer;
}

#pragma mark - 圆形缩小
- (void)circleShrinkAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 起始vc
    UIViewController<FTCustomTransitioning> *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC = (UIViewController<FTCustomTransitioning> *)[self topViewControllerForController:fromVC];
    
    // 最终vc 的topVC (本项目这个present行为实际上是tabbarController执行的)
    UIViewController<FTCustomTransitioning>*toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC = (UIViewController<FTCustomTransitioning>*)[self topViewControllerForController:toVC];
    CGRect toRect;
    if ([toVC respondsToSelector:@selector(circleAnimationStartRect)]) {
        toRect = [toVC circleAnimationStartRect];
    }else {
        toRect = CGRectMake(0, 0, 40, 40);
        toRect.origin = toVC.view.center;
    }
    
    // 将最终view位置放到0以便于在fromView消失的时候能看到最终view
    UIView *containerView = transitionContext.containerView;
    if (toVC.tabBarController) {
        [containerView insertSubview:toVC.tabBarController.view atIndex:0];
    }else if (toVC.navigationController) {
        [containerView insertSubview:toVC.navigationController.view atIndex:0];
    }else {
        [containerView insertSubview:toVC.view atIndex:0];
    }
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    CGFloat x = MAX(toRect.origin.x, containerView.bounds.size.width - toRect.origin.x);
    CGFloat y = MAX(toRect.origin.y, containerView.bounds.size.height - toRect.origin.y);
    CGFloat radius = sqrtf(pow(x, 2) + pow(y, 2));
    UIBezierPath *toValue = [UIBezierPath bezierPathWithOvalInRect:toRect];
    UIBezierPath *fromValue = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    animation.fromValue = (id)fromValue.CGPath;
    animation.toValue = (id)toValue.CGPath;
    animation.duration = [self transitionDuration:nil];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setValue:transitionContext forKey:@"transitionContext"];
    animation.delegate = self;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = toValue.CGPath;
    [maskLayer addAnimation:animation forKey:nil];
    fromVC.view.layer.mask = maskLayer;
}

- (UIViewController*)topViewControllerForController:(UIViewController *)controller {
    UIViewController *topViewController = controller;
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *navi = [(UITabBarController*)controller selectedViewController];
        if ([navi isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController*)navi topViewController];
        }else {
            topViewController = navi;
        }
    }else if ([controller isKindOfClass:[UINavigationController class] ]) {
        topViewController = [(UINavigationController*)controller topViewController];
    }
    return topViewController;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    switch (_type) {
        case FTCustomTransitioningCircleMagnify:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
            
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            toVC = [self topViewControllerForController:toVC];
            toVC.view.layer.mask = nil;
        }
            break;
        case FTCustomTransitioningCircleShrink: {
            {
                id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                if ([transitionContext transitionWasCancelled]) {
                    // 起始vc
                    UIViewController<FTCustomTransitioning> *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
                    fromVC = (UIViewController<FTCustomTransitioning> *)[self topViewControllerForController:fromVC];
                    fromVC.view.layer.mask = nil;
                }
            }
        }
            
        default:
            break;
    }
}
@end
