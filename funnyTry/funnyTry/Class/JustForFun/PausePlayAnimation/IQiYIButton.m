//
//  IQiYIButton.m
//  funnyTry
//
//  Created by SGQ on 2017/12/14.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "IQiYIButton.h"

//其它动画时长
static CGFloat trangleAnimationDuration = 0.5f;
//位移动画时长
static CGFloat lineAnimationDuration = 0.3f;
//线条颜色
#define LineColor [UIColor colorWithRed:12/255.0 green:190/255.0 blue:6/255.0 alpha:1]
//三角动画名称
#define TriangleAnimationName @"TriangleAnimationName"
//右侧直线动画名称
#define RightLineAnimationName @"RightLineAnimationName"
//name key
#define AnimationNameKey @"AnimationNameKey"

@interface IQiYIButton ()<CAAnimationDelegate>
@property (nonatomic, strong) CAShapeLayer *leftLineLayer;
@property (nonatomic, strong) CAShapeLayer *rightLineLayer;
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, assign) BOOL animationing;
@end

@implementation IQiYIButton

- (instancetype)initWithFrame:(CGRect)frame playState:(IQiYIButtonState)playState {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        
        if (playState == IQiYIButtonStatePlay) {
            self.playState = playState;
        }
    }
    return self;
}

- (void)buildUI {
    [self addLeftLineLayer];
    [self addRightLineLayer];
    [self addTriangleLayer];
    [self addCircleLayer];
}

- (void)addLeftLineLayer {
    CGFloat a = CGRectGetWidth(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a * 0.2, 0)];
    [path addLineToPoint:CGPointMake(a * 0.2, a)];
    
    _leftLineLayer = [CAShapeLayer layer];
    _leftLineLayer.path = path.CGPath;
    _leftLineLayer.lineWidth = [self lineWidth];
    _leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLineLayer.strokeColor = LineColor.CGColor;
    _leftLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_leftLineLayer];
}

- (void)addRightLineLayer {
    CGFloat a = CGRectGetWidth(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8, a)];
    [path addLineToPoint:CGPointMake(a*0.8, 0)];
    
    _rightLineLayer = [CAShapeLayer layer];
    _rightLineLayer.path = path.CGPath;
    _rightLineLayer.lineWidth = [self lineWidth];
    _rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLineLayer.strokeColor = LineColor.CGColor;
    _rightLineLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:_rightLineLayer];
}

- (void)addTriangleLayer {
    CGFloat a = CGRectGetWidth(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2, a*0.2)];
    [path addLineToPoint:CGPointMake(a*0.2, 0)];
    [path addLineToPoint:CGPointMake(a, a*0.5)];
    [path addLineToPoint:CGPointMake(a*0.2, a)];
    [path addLineToPoint:CGPointMake(a*0.2, a * 0.2)];
    
    _triangleLayer = [CAShapeLayer layer];
    _triangleLayer.path = path.CGPath;
    _triangleLayer.lineWidth = [self lineWidth];
    _triangleLayer.fillColor = [UIColor clearColor].CGColor;
    _triangleLayer.strokeColor = LineColor.CGColor;
    _triangleLayer.lineCap = kCALineCapRound;
    _triangleLayer.lineJoin = kCALineCapRound;
    _triangleLayer.strokeEnd = 0;
    [self.layer addSublayer:_triangleLayer];
}

- (void)addCircleLayer {
    CGFloat a = CGRectGetWidth(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a* 0.8, a * 0.8)];
    [path addArcWithCenter:CGPointMake(a * 0.5, a * 0.8) radius:a * 0.3 startAngle:0 endAngle:M_PI clockwise:YES
     ];
    
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.path = path.CGPath;
    _circleLayer.lineWidth = [self lineWidth];
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.strokeColor = LineColor.CGColor;
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.strokeEnd = 0;
    [self.layer addSublayer:_circleLayer];
}

- (CGFloat)lineWidth {
    return CGRectGetWidth(self.bounds) * 0.2;
}

#pragma mark - setter playState
- (void)setPlayState:(IQiYIButtonState)playState {
    if (self.animationing  || playState == _playState) {return;}
    
    _playState = playState;
    _animationing = YES;
    
    if (playState == IQiYIButtonStatePlay) {
        // 竖线动画
        [self lineAnimationToPlayState];
        
        // 接下来的
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lineAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self remianedAnimationToPlayState];
        });
        
    }else if (playState == IQiYIButtonStatePause) {
        // 竖线动画
        [self lineAnimationToPauseState];
        
        // 接下来的
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(trangleAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self remianedAnimationToPauseState];
        });

    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((lineAnimationDuration + trangleAnimationDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _animationing = NO;
    });
}
#pragma mark - 至play状态动画
- (void)lineAnimationToPlayState{
    CGFloat a = CGRectGetWidth(self.bounds);
    
    //左线变短
    UIBezierPath *leftPath1 = [UIBezierPath bezierPath];
    [leftPath1 moveToPoint:CGPointMake(a * 0.2, a * 0.4)];
    [leftPath1 addLineToPoint:CGPointMake(a * 0.2, a)];
    
    _leftLineLayer.path = leftPath1.CGPath;
    [_leftLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration / 2.0] forKey:nil];
    
    //右线上移
    UIBezierPath *rightPath1 = [UIBezierPath bezierPath];
    [rightPath1 moveToPoint:CGPointMake(a*0.8, a*0.8)];
    [rightPath1 addLineToPoint:CGPointMake(a*0.8, -a*0.2)];
    
    _rightLineLayer.path = rightPath1.CGPath;
    [_rightLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration/2.0] forKey:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lineAnimationDuration/2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //左线居中
        UIBezierPath *leftPath2 = [UIBezierPath bezierPath];
        [leftPath2 moveToPoint:CGPointMake(a * 0.2, a * 0.2)];
        [leftPath2 addLineToPoint:CGPointMake(a * 0.2, a * 0.8)];
        
        _leftLineLayer.path = leftPath2.CGPath;
        [_leftLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration/2.0] forKey:nil];
        
        //右线居中
        UIBezierPath *rightPath2 = [UIBezierPath bezierPath];
        [rightPath2 moveToPoint:CGPointMake(a*0.8, a*0.8)];
        [rightPath2 addLineToPoint:CGPointMake(a*0.8, a*0.2)];
        
        _rightLineLayer.path = rightPath2.CGPath;
        [_rightLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration/2.0] forKey:nil];
        
    });
}

- (void)remianedAnimationToPlayState{
    // 三角形从0到全部
    [self strokeEndAnimationFrom:0 to:1 onLayer:_triangleLayer duration:trangleAnimationDuration delegate:self name:TriangleAnimationName];
    
    // 右线从全部到0
    [self strokeEndAnimationFrom:1 to:0 onLayer:_rightLineLayer duration:trangleAnimationDuration/4.0 delegate:self name:RightLineAnimationName];
    
    // 半圆弧从0到全部
    [self strokeEndAnimationFrom:0 to:1 onLayer:_circleLayer duration:trangleAnimationDuration/4.0 delegate:nil name:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(trangleAnimationDuration/4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 半圆弧全部到0
        [self strokeStartAnimationFrom:0 to:1 onLayer:_circleLayer duration:trangleAnimationDuration/4.0 delegate:nil name:nil];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(trangleAnimationDuration/2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 左线从全部到0
        [self strokeEndAnimationFrom:1 to:0 onLayer:_leftLineLayer duration:trangleAnimationDuration/2.0 delegate:nil name:nil];
    });
}

#pragma mark -至pause状态
- (void)lineAnimationToPauseState{
    // 左线从到0全部
    [self strokeEndAnimationFrom:0 to:1 onLayer:_leftLineLayer duration:trangleAnimationDuration/2.0 delegate:nil name:nil];
    
    // 三角形从全部到0
    [self strokeEndAnimationFrom:1 to:0 onLayer:_triangleLayer duration:trangleAnimationDuration delegate:self name:TriangleAnimationName];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(trangleAnimationDuration/2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 半圆弧0到全部
        [self strokeStartAnimationFrom:1 to:0 onLayer:_circleLayer duration:trangleAnimationDuration/4.0 delegate:nil name:nil];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(trangleAnimationDuration *0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 半圆弧全部到0
        [self strokeEndAnimationFrom:1 to:0 onLayer:_circleLayer duration:trangleAnimationDuration/4.0 delegate:nil name:nil];
        
        // 右线从0到全部
        [self strokeEndAnimationFrom:0 to:1 onLayer:_rightLineLayer duration:trangleAnimationDuration/4.0 delegate:self name:RightLineAnimationName];
        
    });
}

- (void)remianedAnimationToPauseState{
    CGFloat a = CGRectGetWidth(self.bounds);
    
    //左线下移
    UIBezierPath *leftPath1 = [UIBezierPath bezierPath];
    [leftPath1 moveToPoint:CGPointMake(a*0.2, a*0.4)];
    [leftPath1 addLineToPoint:CGPointMake(a*0.2,a)];
    
    _leftLineLayer.path = leftPath1.CGPath;
    [_leftLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration / 2.0] forKey:nil];
    
    //右线变长
    UIBezierPath *rightPath1 = [UIBezierPath bezierPath];
    [rightPath1 moveToPoint:CGPointMake(a*0.8, a*0.8)];
    [rightPath1 addLineToPoint:CGPointMake(a*0.8, -a*0.2)];
    
    _rightLineLayer.path = rightPath1.CGPath;
    [_rightLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration/2.0] forKey:nil];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(lineAnimationDuration/2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //左线伸长
        UIBezierPath *leftPath2 = [UIBezierPath bezierPath];
        [leftPath2 moveToPoint:CGPointMake(a * 0.2, 0)];
        [leftPath2 addLineToPoint:CGPointMake(a * 0.2, a)];
        
        _leftLineLayer.path = leftPath2.CGPath;
        [_leftLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration/2.0] forKey:nil];
        
        //右线居中
        UIBezierPath *rightPath2 = [UIBezierPath bezierPath];
        [rightPath2 moveToPoint:CGPointMake(a*0.8, a)];
        [rightPath2 addLineToPoint:CGPointMake(a*0.8, 0)];
        
        _rightLineLayer.path = rightPath2.CGPath;
        [_rightLineLayer addAnimation:[self pathAnimationWithDuration:lineAnimationDuration/2.0] forKey:nil];
    });
}


#pragma mark - path animation
- (CABasicAnimation *)pathAnimationWithDuration:(CGFloat)duration {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = duration;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    return pathAnimation;
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
    [animation setValue:name forKey:AnimationNameKey];
    [layer addAnimation:animation forKey:nil];
    return animation;
}

- (CABasicAnimation*)strokeStartAnimationFrom:(CGFloat)from to:(CGFloat)to onLayer:(CAShapeLayer*)layer duration:(CGFloat)duration  delegate:(id<CAAnimationDelegate>)delegate name:(NSString*)name{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"strokeStart";
    animation.duration = duration;
    animation.fromValue = @(from);
    animation.toValue = @(to);
    animation.delegate = delegate;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setValue:name forKey:AnimationNameKey];
    [layer addAnimation:animation forKey:nil];
    return animation;
}


#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim {
    NSString *name = [anim valueForKey:AnimationNameKey];
    if ([name isEqualToString:RightLineAnimationName]) {
        _rightLineLayer.lineCap = kCALineCapRound;
    }else if ([name isEqualToString:TriangleAnimationName]){
        _triangleLayer.lineCap = kCALineCapRound;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *name = [anim valueForKey:AnimationNameKey];
    if ([name isEqualToString:RightLineAnimationName] && self.playState == IQiYIButtonStatePlay) {
        _rightLineLayer.lineCap = kCALineCapButt;
    }
    if ([name isEqualToString:TriangleAnimationName]) {
        _triangleLayer.lineCap = kCALineCapButt;
    }
}
@end
