//
//  FTCustomTransitioning.m
//  funnyTry
//
//  Created by SGQ on 2017/12/4.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomTransitioning.h"
#import "UIView+Screenshot.h"

@interface FTCustomTransitioning ()<CAAnimationDelegate>
@property (nonatomic, assign) FTCustomTransitioningType type;
@property (nonatomic, copy) NSString *actionType;
@end

@implementation FTCustomTransitioning

- (instancetype)initWithTransitioningWithType:(FTCustomTransitioningType)type actionType:(NSString *)actionType{
    if (self = [super init]) {
        _type = type;
        _actionType = actionType;
    }
    return self;
}

+ (instancetype)transitioningWithType:(FTCustomTransitioningType)type actionType:(NSString *)actionType{
    return [[self alloc] initWithTransitioningWithType:type actionType:actionType];
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
        case FTCustomTransitioningFade:
        case FTCustomTransitioningPush:
        case FTCustomTransitioningMoveIn:
        case FTCustomTransitioningReveal:
        case FTCustomTransitioningOgFlip:
        case FTCustomTransitioningCube:
        case FTCustomTransitioningSuckEffect:
        case FTCustomTransitioningRippleEffect:
        case FTCustomTransitioningPageCurl:
        case FTCustomTransitioningPageUnCurl:
        case FTCustomTransitioningCameraIrisHollowOpen:
        case FTCustomTransitioningCameraIrisHollowClose:
            [self systemTransiton:transitionContext];
            break;
        default:
            break;
    }
}

#pragma mark - 圆形放大
- (void)circleMagnifyAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 起始vc topVC (本项目这个present行为实际上是tabbarController执行的)
    UIViewController<FTCustomTransitioning> *fromVC = (UIViewController<FTCustomTransitioning> *)[self fromVC:transitionContext];
    
    // 最终vc
    UIViewController *toVC = [self toVC:transitionContext];
   
    // 将present的视图添加到container上去
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toVC.view];
    
    //创建动画
    CGRect fromRect;
    if ([fromVC respondsToSelector:@selector(circleAnimationStartRect)]) {
        fromRect = [fromVC circleAnimationStartRect];
    }else {
        fromRect = CGRectMake(0, 0, 40, 40);
        fromRect.origin = fromVC.view.center;
    }
    
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
    UIViewController *fromVC = [self fromVC:transitionContext];
    
    // 最终vc的topVC (本项目这个present行为实际上是tabbarController执行的)
    UIViewController<FTCustomTransitioning>*toVC = (UIViewController<FTCustomTransitioning>*)[self toVC:transitionContext];

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
    CGRect toRect;
    if ([toVC respondsToSelector:@selector(circleAnimationStartRect)]) {
        toRect = [toVC circleAnimationStartRect];
    }else {
        toRect = CGRectMake(0, 0, 40, 40);
        toRect.origin = toVC.view.center;
    }
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

- (void)systemTransiton:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 起始vc
    UIViewController *fromVC = [self fromVC:transitionContext];
    
    // 最终vc的topVC (本项目这个present行为实际上是tabbarController执行的)
    UIViewController<FTCustomTransitioning>*toVC = (UIViewController<FTCustomTransitioning>*)[self toVC:transitionContext];
    
    // 将最终视图添加到containerView上
    if ([self.actionType isEqualToString:@"present"]) {
        UIView *containerView = transitionContext.containerView;
        [containerView addSubview:toVC.view];
    
    }else if ([self.actionType isEqualToString:@"dismiss"]) {
        UIView *containerView = transitionContext.containerView;
        if (toVC.tabBarController) {
            [containerView insertSubview:toVC.tabBarController.view atIndex:0];
        }else if (toVC.navigationController) {
            [containerView insertSubview:toVC.navigationController.view atIndex:0];
        }else {
            [containerView insertSubview:toVC.view atIndex:0];
        }
    }
    
    //创建动画附属imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:transitionContext.containerView.bounds];
    UIImage *fromImage = nil;
    if (fromVC.navigationController) {
       fromImage = [fromVC.navigationController.view convertViewToImage];
    }else {
        fromImage = [fromVC.view convertViewToImage];
    }
    
    UIImage *toImage = nil;
    if (toVC.navigationController) {
        toImage =  [toVC.navigationController.view convertViewToImage];
    }else {
        toImage =  [toVC.view convertViewToImage];
    }
    imageView.image = fromImage;
    [transitionContext.containerView addSubview:imageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSystemTransitionWithToImage:toImage context:transitionContext];
    });
}
    

- (void)addSystemTransitionWithToImage:(UIImage *)toImage context:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIImageView *imageView = transitionContext.containerView.subviews.lastObject;
    CATransition *animation = [CATransition animation];
    animation.duration = [self transitionDuration:transitionContext] - 0.05;
    switch (self.type) {
        case FTCustomTransitioningFade:
            animation.type = @"fade";
            break;
        case FTCustomTransitioningPush:
            animation.type = @"push";
            break;
        case FTCustomTransitioningMoveIn:
            animation.type = @"moveIn";
            break;
        case FTCustomTransitioningReveal:
            animation.type = @"reveal";
            break;
        case FTCustomTransitioningOgFlip:
            animation.type = @"oglFlip";
            break;
        case FTCustomTransitioningCube:
            animation.type = @"cube";
            break;
        case FTCustomTransitioningSuckEffect:
            animation.type = @"suckEffect";
            break;
        case FTCustomTransitioningRippleEffect:
            animation.type = @"rippleEffect";
            break;
        case FTCustomTransitioningPageCurl:
            animation.type = @"pageCurl";
            break;
        case FTCustomTransitioningPageUnCurl:
            animation.type = @"pageUnCurl";
            break;
        case FTCustomTransitioningCameraIrisHollowOpen:
            animation.type = @"cameraIrisHollowOpen";
            break;
        case FTCustomTransitioningCameraIrisHollowClose:
            animation.type = @"cameraIrisHollowClose";
            break;
        default:
            break;
    }
    if ([self.actionType isEqualToString:@"present"]) {
        animation.subtype = kCATransitionFromRight;
    }else if ([self.actionType isEqualToString:@"dismiss"]) {
        animation.subtype = kCATransitionFromLeft;
    }
    animation.delegate = self;
    [animation setValue:imageView forKey:@"imageViewKey"];
    [animation setValue:transitionContext forKey:@"transitionContext"];
    [imageView.layer addAnimation:animation forKey:nil];
    imageView.image = toImage;
}

// 起始vc的topVC(本项目这个present行为实际上是tabbarController执行的)
- (UIViewController *)fromVC:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC = [self topViewControllerForController:fromVC];
    return fromVC;
}

// 最终vc
- (UIViewController*)toVC:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC = [self topViewControllerForController:toVC];
    return toVC;
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
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                // 起始vc
                UIViewController<FTCustomTransitioning> *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
                fromVC = (UIViewController<FTCustomTransitioning> *)[self topViewControllerForController:fromVC];
                fromVC.view.layer.mask = nil;
            }
        }
            break;
        case FTCustomTransitioningFade:
        case FTCustomTransitioningPush:
        case FTCustomTransitioningMoveIn:
        case FTCustomTransitioningReveal:
        case FTCustomTransitioningOgFlip:
        case FTCustomTransitioningCube:
        case FTCustomTransitioningSuckEffect:
        case FTCustomTransitioningRippleEffect:
        case FTCustomTransitioningPageCurl:
        case FTCustomTransitioningPageUnCurl:
        case FTCustomTransitioningCameraIrisHollowOpen:
        case FTCustomTransitioningCameraIrisHollowClose:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            
            UIImageView *imageView = [anim valueForKey:@"imageViewKey"];
            [imageView removeFromSuperview];
            imageView = nil;
        }
            break;
        default:
            break;
    }
}
@end
