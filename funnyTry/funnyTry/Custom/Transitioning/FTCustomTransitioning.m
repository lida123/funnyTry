//
//  FTCustomTransitioning.m
//  funnyTry
//
//  Created by SGQ on 2017/12/4.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomTransitioning.h"
#import "UIView+Screenshot.h"
#import "UIView+anchorPoint.h"

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
    if ([self.actionType isEqualToString:@"push"]) {
        [self doPushAnimation:transitionContext];
        return;
    }else if ([self.actionType isEqualToString:@"pop"]) {
        [self doPopAnimation:transitionContext];
        return;
    }
    
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

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //对tempView做动画，避免bug;
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    fromVC.view.hidden = YES;
    [containerView insertSubview:toVC.view atIndex:0];
    [tempView setAnchorPointTo:CGPointMake(0, 0.5)];
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -0.002;
    containerView.layer.sublayerTransform = transfrom3d;
    //增加阴影
    CAGradientLayer *fromGradient = [CAGradientLayer layer];
    fromGradient.frame = fromVC.view.bounds;
    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,
                            (id)[UIColor blackColor].CGColor];
    fromGradient.startPoint = CGPointMake(0.0, 0.5);
    fromGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *fromShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
    fromShadow.backgroundColor = [UIColor clearColor];
    [fromShadow.layer insertSublayer:fromGradient atIndex:1];
    fromShadow.alpha = 0.0;
    [tempView addSubview:fromShadow];
    CAGradientLayer *toGradient = [CAGradientLayer layer];
    toGradient.frame = fromVC.view.bounds;
    toGradient.colors = @[(id)[UIColor blackColor].CGColor,
                          (id)[UIColor blackColor].CGColor];
    toGradient.startPoint = CGPointMake(0.0, 0.5);
    toGradient.endPoint = CGPointMake(0.8, 0.5);
    UIView *toShadow = [[UIView alloc]initWithFrame:fromVC.view.bounds];
    toShadow.backgroundColor = [UIColor clearColor];
    [toShadow.layer insertSublayer:toGradient atIndex:1];
    toShadow.alpha = 1.0;
    [toVC.view addSubview:toShadow];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        fromShadow.alpha = 1.0;
        toShadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            [tempView removeFromSuperview];
            fromVC.view.hidden = NO;
        }
    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    //拿到push时候的
    UIView *tempView = containerView.subviews.lastObject;
    [containerView addSubview:toVC.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.layer.transform = CATransform3DIdentity;
        fromVC.view.subviews.lastObject.alpha = 1.0;
        tempView.subviews.lastObject.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
        }else{
            [transitionContext completeTransition:YES];
            [tempView removeFromSuperview];
            toVC.view.hidden = NO;
        }
    }];
    
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
    CGRect fromRect = CGRectMake(0, 0, 40, 40);
    fromRect.origin = fromVC.view.center;
    
    
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
    [containerView insertSubview:toVC.view atIndex:0];
    
    
    // 创建动画
    CGRect  toRect = CGRectMake(0, 0, 40, 40);
    toRect.origin = toVC.view.center;
  
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
    UIViewController *toVC = [self toVC:transitionContext];
    
    // 将最终视图添加到containerView上
    if ([self.actionType isEqualToString:@"present"] || [self.actionType isEqualToString:@"push"]) {
        UIView *containerView = transitionContext.containerView;
        [containerView addSubview:toVC.view];
    
    }else if ([self.actionType isEqualToString:@"dismiss"] || [self.actionType isEqualToString:@"pop"]) {
        UIView *containerView = transitionContext.containerView;
        [containerView insertSubview:toVC.view atIndex:0];
    }
    
    //创建动画附属imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:transitionContext.containerView.bounds];
    UIImage *fromImage = [fromVC.view convertViewToImage];
    UIImage *toImage =  [toVC.view convertViewToImage];
    imageView.image = fromImage;
    [transitionContext.containerView addSubview:imageView];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSystemTransitionWithToImage:toImage tempImageV:imageView context:transitionContext];
    });
}
    

- (void)addSystemTransitionWithToImage:(UIImage *)toImage tempImageV:(UIImageView*)tempImageV context:(id<UIViewControllerContextTransitioning>)transitionContext {
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
    if ([self.actionType isEqualToString:@"present"] || [self.actionType isEqualToString:@"push"]) {
        animation.subtype = kCATransitionFromRight;
    }else if ([self.actionType isEqualToString:@"dismiss"] || [self.actionType isEqualToString:@"pop"]) {
        animation.subtype = kCATransitionFromLeft;
    }
    animation.delegate = self;
    [animation setValue:tempImageV forKey:@"imageViewKey"];
    [animation setValue:transitionContext forKey:@"transitionContext"];
    [tempImageV.layer addAnimation:animation forKey:@"animationkey"];
    tempImageV.image = toImage;
}

- (UIViewController *)fromVC:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    return fromVC;
}

// 最终vc
- (UIViewController*)toVC:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    return toVC;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    switch (_type) {
        case FTCustomTransitioningCircleMagnify:{
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:YES];
            
            UIViewController *toVC = [self toVC:transitionContext];
            toVC.view.layer.mask = nil;
        }
            break;
        case FTCustomTransitioningCircleShrink: {
            id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                // 起始vc
                UIViewController *fromVC = [self fromVC:transitionContext];
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
