//
//  YouKuPlayButton.m
//  funnyTry
//
//  Created by SGQ on 2017/12/14.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "YouKuPlayButton.h"
//动画时长
static CGFloat animationDuration = 0.35f;
//线条颜色
#define BLueColor [UIColor colorWithRed:62/255.0 green:157/255.0 blue:254/255.0 alpha:1]
#define LightBLueColor [UIColor colorWithRed:87/255.0 green:188/255.0 blue:253/255.0 alpha:1]
#define RedColor [UIColor colorWithRed:228/255.0 green:35/255.0 blue:6/255.0 alpha:0.8]

@interface YouKuPlayButton()
@property (nonatomic, strong) CAShapeLayer *leftLineLayer;
@property (nonatomic, strong) CAShapeLayer *rightLineLayer;
@property (nonatomic, strong) CAShapeLayer *leftCircleLayer;
@property (nonatomic, strong) CAShapeLayer *rightCirlceLayer;
@property (nonatomic, strong) CALayer *triangleCotainer;
@property (nonatomic, assign) BOOL animationing;
@end

@implementation YouKuPlayButton

- (instancetype)initWithFrame:(CGRect)frame playState:(YouKuButtonState)playState {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        
        if (playState == YouKuButtonStatePlay) {
            self.playState = playState;
        }
    }
    return self;
}

- (void)buildUI {
    [self addLeftCircleLayer];
    [self addRightCirlceLayer];
    [self addLeftLineLayer];
    [self addRightLineLayer];
    [self addCenterTriangleLayer];
}

- (void)addLeftLineLayer {
    CGFloat a = CGRectGetWidth(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2, a *0.9)];
    [path addLineToPoint:CGPointMake(a*0.2, a*0.1)];
    
    _leftLineLayer = [CAShapeLayer layer];
    _leftLineLayer.path = path.CGPath;
    _leftLineLayer.lineWidth = [self lineWidth];
    _leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLineLayer.strokeColor = BLueColor.CGColor;
    _leftLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_leftLineLayer];
}

- (void)addRightLineLayer {
    CGFloat a = CGRectGetWidth(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8, a*0.1)];
    [path addLineToPoint:CGPointMake(a*0.8, a*0.9)];
    
    _rightLineLayer = [CAShapeLayer layer];
    _rightLineLayer.path = path.CGPath;
    _rightLineLayer.lineWidth = [self lineWidth];
    _rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLineLayer.strokeColor = BLueColor.CGColor;
    _rightLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_rightLineLayer];
}

- (void)addLeftCircleLayer {
    CGFloat a = CGRectGetWidth(self.bounds);
    
    CGFloat startAngle = M_PI/2.0 + acos(4.0/5.0);
    CGFloat endAngle = startAngle + M_PI;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2, a*0.9)];
    [path addArcWithCenter:CGPointMake(a*0.5, a*0.5) radius:a*0.5 startAngle:startAngle endAngle:endAngle clockwise:NO];
    
    _leftCircleLayer = [CAShapeLayer layer];
    _leftCircleLayer.path = path.CGPath;
    _leftCircleLayer.lineWidth = [self lineWidth];
    _leftCircleLayer.fillColor = [UIColor clearColor].CGColor;
    _leftCircleLayer.strokeColor = LightBLueColor.CGColor;
    _leftCircleLayer.lineCap = kCALineCapRound;
    _leftCircleLayer.strokeEnd = 0;
    [self.layer addSublayer:_leftCircleLayer];
}

- (void)addRightCirlceLayer {
    CGFloat a = self.layer.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8,a*0.1)];
    CGFloat startAngle = -asin(4.0/5.0);
    CGFloat endAngle = startAngle - M_PI;
    [path addArcWithCenter:CGPointMake(a*0.5, a*0.5) radius:0.5*a startAngle:startAngle endAngle:endAngle clockwise:false];
    
    _rightCirlceLayer = [CAShapeLayer layer];
    _rightCirlceLayer.path = path.CGPath;
    _rightCirlceLayer.lineWidth = [self lineWidth];
    _rightCirlceLayer.fillColor = [UIColor clearColor].CGColor;
    _rightCirlceLayer.strokeColor = LightBLueColor.CGColor;
    _rightCirlceLayer.lineCap = kCALineCapRound;
    _rightCirlceLayer.strokeEnd = 0;
    [self.layer addSublayer:_rightCirlceLayer];
}

- (void)addCenterTriangleLayer {
    CGFloat a = self.layer.bounds.size.width;
    //初始化容器
    _triangleCotainer = [CALayer layer];
    _triangleCotainer.bounds = CGRectMake(0, 0, 0.4*a, 0.35*a);
    _triangleCotainer.position = CGPointMake(a*0.5, a*0.55);
    _triangleCotainer.opacity = 0;
    [self.layer addSublayer:_triangleCotainer];
    
    //容器宽高
    CGFloat b = _triangleCotainer.bounds.size.width;
    CGFloat c = _triangleCotainer.bounds.size.height;
    
    //第一条边
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(0,0)];
    [path1 addLineToPoint:CGPointMake(b/2,c)];
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.path = path1.CGPath;
    layer1.fillColor = [UIColor clearColor].CGColor;
    layer1.strokeColor = RedColor.CGColor;
    layer1.lineWidth = [self lineWidth];
    layer1.lineCap = kCALineCapRound;
    layer1.lineJoin = kCALineJoinRound;
    layer1.strokeEnd = 1;
    [_triangleCotainer addSublayer:layer1];
    
    //第二条边
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(b,0)];
    [path2 addLineToPoint:CGPointMake(b/2,c)];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.path = path2.CGPath;
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.strokeColor = RedColor.CGColor;
    layer2.lineWidth = [self lineWidth];
    layer2.lineCap = kCALineCapRound;
    layer2.lineJoin = kCALineJoinRound;
    layer2.strokeEnd = 1;
    [_triangleCotainer addSublayer:layer2];
}

- (CGFloat)lineWidth {
    return self.layer.bounds.size.width * 0.18;
}
#pragma mark - setter playstate
- (void)setPlayState:(YouKuButtonState)playState {
    if (self.animationing  || playState == _playState) {return;}
    self.animationing = YES;
    
    _playState = playState;
    if (playState == YouKuButtonStatePlay) {
        [self playStateAnimation];
    }else if (playState == YouKuButtonStatePause) {
        [self pauseStateAnimation];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.animationing = NO;
    });
}

- (void)playStateAnimation {
    //左线缩短到0
    [self strokeEndAnimationFrom:1 to:0 onLayer:_leftLineLayer duration:animationDuration/2.0 delegate:nil name:nil];
    
    //左圆弧从0到全部
    [self strokeEndAnimationFrom:0 to:1 onLayer:_leftCircleLayer duration:animationDuration delegate:nil name:nil];
    
    //右线缩短到0
    [self strokeEndAnimationFrom:1 to:0 onLayer:_rightLineLayer duration:animationDuration/2.0 delegate:nil name:nil];
    
    //右圆弧从0到全部
    [self strokeEndAnimationFrom:0 to:1 onLayer:_rightCirlceLayer duration:animationDuration delegate:nil name:nil];
    
    //旋转动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration/4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self rotateAnimation:NO];
    });
    
    //图明度动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration/2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self actionTriangleAlphaAnimationFrom:0 to:1 duration:animationDuration/2.0];
    });
}

- (void)pauseStateAnimation {
    //左圆弧从全部到0
    [self strokeEndAnimationFrom:1 to:0 onLayer:_leftCircleLayer duration:animationDuration delegate:nil name:nil];
    
    //右圆弧从全部到0
    [self strokeEndAnimationFrom:1 to:0 onLayer:_rightCirlceLayer duration:animationDuration delegate:nil name:nil];
    
    //隐藏播放三角动画
    [self actionTriangleAlphaAnimationFrom:1 to:0 duration:animationDuration/2];
    //旋转动画
    [self rotateAnimation:true];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //左线从0到1
        [self strokeEndAnimationFrom:0 to:1 onLayer:_leftLineLayer duration:animationDuration/2.0 delegate:nil name:nil];

        //右线从0到1
        [self strokeEndAnimationFrom:0 to:1 onLayer:_rightLineLayer duration:animationDuration/2.0 delegate:nil name:nil];;
    });
}

- (void)rotateAnimation:(BOOL)clockwise {
    CGFloat startAngle = 0;
    CGFloat endAngle = -M_PI_2;
    CGFloat duration = animationDuration * 0.75;
    if (clockwise) {
        startAngle = -M_PI_2;
        endAngle = 0;
        duration = animationDuration;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = duration;
    animation.fromValue = @(startAngle);
    animation.toValue = @(endAngle);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:nil];
}

- (void)actionTriangleAlphaAnimationFrom:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = duration; // 持续时间
    alphaAnimation.fromValue = @(from);
    alphaAnimation.toValue = @(to);
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    [alphaAnimation setValue:@"alphaAnimation" forKey:@"animationName"];
    [_triangleCotainer addAnimation:alphaAnimation forKey:nil];
}

#pragma mark - strokend animation
- (CABasicAnimation*)strokeEndAnimationFrom:(CGFloat)from to:(CGFloat)to onLayer:(CAShapeLayer*)layer duration:(CGFloat)duration  delegate:(id<CAAnimationDelegate>)delegate name:(NSString*)name{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"strokeEnd";
    animation.duration = duration;
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.delegate = delegate;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:nil];
    return animation;
}
@end
