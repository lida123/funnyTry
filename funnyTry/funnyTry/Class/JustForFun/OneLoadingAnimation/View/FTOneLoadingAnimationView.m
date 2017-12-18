//
//  FTOneLoadingAnimationView.m
//  funnyTry
//
//  Created by SGQ on 2017/12/18.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTOneLoadingAnimationView.h"
#import "FTLoadingCircleLayer.h"

static CGFloat const kLineWidth = 6;

@interface FTOneLoadingAnimationView ()<CAAnimationDelegate>
@property (nonatomic, strong) FTLoadingCircleLayer *loadingCircleLayer;
@property (nonatomic, strong) CAShapeLayer *moveArcLayer;//短圆弧和下落的细线
@property (nonatomic, strong) CAShapeLayer *fallThickLayer;//下落的粗线
@property (nonatomic, strong) CAShapeLayer *ArcLayer;
@property (nonatomic, strong) CAShapeLayer *leftAppearLayer;
@property (nonatomic, strong) CAShapeLayer *rightAppearLayer;
@property (nonatomic, strong) CAShapeLayer *checkMarkLayer;

@property (nonatomic, strong) UIColor *likeBlackColor;
@property (nonatomic, strong) UIColor *likeGreenColor;
@property (nonatomic, strong) UIColor *likeRedColor;
@end;

@implementation FTOneLoadingAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.likeBlackColor = [UIColor colorWithRed:0x46/255.0 green:0x4d/255.0 blue:0x65/255.0 alpha:1.0];
        self.likeGreenColor = [UIColor colorWithRed:0x32/255.0 green:0xa9/255.0 blue:0x82/255.0 alpha:1.0];
        self.likeRedColor = [UIColor colorWithRed:0xff/255.0 green:0x61/255.0 blue:0x51/255.0 alpha:1.0];
    }
    return self;
}

- (void)startSuccessAnimation {
    if (!self.animationing) {
        self.animationing = YES;
        
        [self.checkMarkLayer removeFromSuperlayer];
        [self.loadingCircleLayer removeFromSuperlayer];
        
        [self step1];
    }
}

- (void)step1 {
    // 画大圆圈
    _loadingCircleLayer = [FTLoadingCircleLayer layer];
    _loadingCircleLayer.bounds = self.bounds;
    _loadingCircleLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    _loadingCircleLayer.lineColor = self.likeBlackColor;
    _loadingCircleLayer.lineWidth = kLineWidth;
    [self.layer addSublayer:_loadingCircleLayer];
    
    _loadingCircleLayer.progress = 1;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 1;
    animation.fromValue = @0;
    animation.toValue = @1;
    [animation setValue:@"step1" forKey:@"name"];
    animation.delegate = self;
    [_loadingCircleLayer addAnimation:animation forKey:nil];
}

- (void)step2 {
    // 从大圆圈最右边上滑的短弧线
    _moveArcLayer = [CAShapeLayer layer];
    _moveArcLayer.bounds = self.bounds;
    _moveArcLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    _moveArcLayer.contentsScale = [UIScreen mainScreen].scale;
    _moveArcLayer.lineWidth = kLineWidth;
    _moveArcLayer.fillColor = [UIColor clearColor].CGColor;
    _moveArcLayer.strokeColor = self.likeBlackColor.CGColor;
    [self.layer addSublayer:_moveArcLayer];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat r = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2.0 - kLineWidth/ 2.0;
    CGFloat d = r/2.0;
    CGFloat radius = 2*r + d;
    [path addArcWithCenter:CGPointMake(center.x - r - d, center.y) radius:radius startAngle:0 endAngle:-asin(2*r/radius) clockwise:NO];
    _moveArcLayer.path = path.CGPath;
    _moveArcLayer.strokeStart = 0.9;
    _moveArcLayer.strokeEnd = 1;
    
    CABasicAnimation *animation0 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation0.fromValue = @0;
    animation0.toValue = @0.9;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @0.1;
    animation1.toValue = @1;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation0,animation1];
    group.duration = 0.5;
    [group setValue:@"step2" forKey:@"name"];
    group.delegate = self;
    [_moveArcLayer addAnimation:group forKey:nil];
}

- (void)step3 {
    // 下落细线从最高点到挨着大圆圈的顶点
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2.0 - kLineWidth/2.0;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat verticalHeight = radius/3.0;
    [path moveToPoint:CGPointMake(center.x, -radius)];
    [path addLineToPoint:CGPointMake(center.x, -radius + verticalHeight)];
    
    _moveArcLayer.strokeStart = 0;
    _moveArcLayer.strokeEnd = 1;
    _moveArcLayer.lineWidth = kLineWidth/2.0;
    _moveArcLayer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.duration = 0.15;
    animation.fromValue = @(center.y);
    animation.toValue = @(center.y + (radius - verticalHeight));
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setValue:@"step3" forKey:@"name"];
    [_moveArcLayer addAnimation:animation forKey:nil];
}

- (void)step4 {
    CGFloat duration = 0.25;
    CGFloat scale = 0.8;
    
     // 下落细线从挨着大圆圈的顶点到全部进入
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2.0 - kLineWidth/ 2.0;
    CGFloat verticalHeight = radius/3.0;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.duration = duration;
    animation.toValue = @(center.y + radius - verticalHeight + radius);
    animation.delegate = self;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_moveArcLayer addAnimation:animation forKey:nil];
    
    
    // 下落粗线
    _fallThickLayer = [CAShapeLayer layer];
    _fallThickLayer.bounds = self.bounds;
    _fallThickLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2.0, CGRectGetHeight(self.bounds)/2.0);
    _fallThickLayer.contentsScale = [UIScreen mainScreen].scale;
    _fallThickLayer.lineWidth = kLineWidth;
    _fallThickLayer.fillColor = [UIColor clearColor].CGColor;
    _fallThickLayer.strokeColor = self.likeBlackColor.CGColor;
    _fallThickLayer.strokeStart = 1-scale;
    _fallThickLayer.strokeEnd = 0.5;
    [self.layer addSublayer:_fallThickLayer];
    
    UIBezierPath *fallPath = [UIBezierPath bezierPath];
    [fallPath moveToPoint:CGPointMake(center.x, 0)];
    [fallPath addLineToPoint:CGPointMake(center.x,CGRectGetHeight(_fallThickLayer.bounds))];
    _fallThickLayer.path = fallPath.CGPath;
    
    
    CABasicAnimation *fallThickStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    fallThickStartAnimation.fromValue = @0;
    fallThickStartAnimation.toValue = @(1-scale);
    
    CABasicAnimation *fallThickEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fallThickEndAnimation.fromValue = @0;
    fallThickEndAnimation.toValue = @0.5;
    
    CAAnimationGroup *fallThickGroupAni = [CAAnimationGroup animation];
    fallThickGroupAni.animations = @[fallThickEndAnimation,fallThickStartAnimation];
    fallThickGroupAni.duration = duration;
    [_fallThickLayer addAnimation:fallThickGroupAni forKey:nil];
    
    
    // 大圆圈形变
    CGRect frame = self.loadingCircleLayer.frame;
    self.loadingCircleLayer.anchorPoint = CGPointMake(0.5, 1);
    self.loadingCircleLayer.frame = frame;
    
    // y scale
    CGFloat yFromScale = 1.0;
    CGFloat yToScale = scale;
    
    // x scale
    CGFloat xFromScale = 1.0;
    CGFloat xToScale = 1.1;
    
    // end status
    self.loadingCircleLayer.transform = CATransform3DMakeScale(xToScale, yToScale, 1);
    
    // animation
    CABasicAnimation *yAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    yAnima.fromValue = @(yFromScale);
    yAnima.toValue = @(yToScale);
    
    CABasicAnimation *xAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    xAnima.fromValue = @(xFromScale);
    xAnima.toValue = @(xToScale);
    
    CAAnimationGroup *anima = [CAAnimationGroup animation];
    anima.animations = @[yAnima, xAnima];
    anima.duration = duration;
    anima.delegate = self;
    [anima setValue:@"step4" forKey:@"name"];
    
    [self.loadingCircleLayer addAnimation:anima forKey:nil];
}

- (void)step5 {

    CGFloat duration = 0.5;
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2.0 - kLineWidth/ 2.0;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 大圆还原成圆形
    self.loadingCircleLayer.transform = CATransform3DIdentity;
    CABasicAnimation *yAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    yAnima.toValue = @(1);
    
    CABasicAnimation *xAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    xAnima.toValue = @(1);
    
    CAAnimationGroup *anima = [CAAnimationGroup animation];
    anima.animations = @[yAnima, xAnima];
    anima.duration = duration;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [self.loadingCircleLayer addAnimation:anima forKey:nil];
    
    // 中间粗线伸直
    CABasicAnimation *fallThickStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    fallThickStartAnimation.toValue = @0;
    
    CABasicAnimation *fallThickEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    fallThickEndAnimation.toValue = @1;
    
    CAAnimationGroup *fallThickGroupAni = [CAAnimationGroup animation];
    fallThickGroupAni.animations = @[fallThickEndAnimation,fallThickStartAnimation];
    fallThickGroupAni.duration = duration;
    fallThickGroupAni.removedOnCompletion = NO;
    fallThickGroupAni.fillMode = kCAFillModeForwards;
    [_fallThickLayer addAnimation:fallThickGroupAni forKey:nil];
    
    // 左下斜线成长到全长
    self.leftAppearLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.leftAppearLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint originPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [path moveToPoint:originPoint];
    CGFloat deltaX = radius * sin(M_PI / 3);
    CGFloat deltaY = radius * cos(M_PI / 3);
    CGPoint destPoint = originPoint;
    destPoint.x -= deltaX;
    destPoint.y += deltaY;
    [path addLineToPoint:destPoint];
    self.leftAppearLayer.path = path.CGPath;
    self.leftAppearLayer.lineWidth = kLineWidth;
    self.leftAppearLayer.strokeColor = self.likeBlackColor.CGColor;
    self.leftAppearLayer.fillColor = nil;
    
    // end status
    CGFloat strokeEnd = 1;
    self.leftAppearLayer.strokeEnd = strokeEnd;
    
    // animation
    CABasicAnimation *leftAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.duration = duration;
    leftAnima.fromValue = @0;
    leftAnima.toValue = @(strokeEnd);
    [self.leftAppearLayer addAnimation:leftAnima forKey:nil];
    
    // 右下斜线成长到全长
    self.rightAppearLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.rightAppearLayer];
    
    UIBezierPath *rightPath = [UIBezierPath bezierPath];
    [rightPath moveToPoint:originPoint];
    destPoint = originPoint;
    destPoint.x += deltaX;
    destPoint.y += deltaY;
    [rightPath addLineToPoint:destPoint];
    self.rightAppearLayer.path = rightPath.CGPath;
    self.rightAppearLayer.lineWidth = kLineWidth;
    self.rightAppearLayer.strokeColor = self.likeBlackColor.CGColor;
    self.rightAppearLayer.fillColor = [UIColor clearColor].CGColor;
    
    // animation
    self.rightAppearLayer.strokeEnd = strokeEnd;
    CABasicAnimation *rightAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightAnima.duration = duration;
    rightAnima.fromValue = @0;
    rightAnima.toValue = @(strokeEnd);
    [rightAnima setValue:@"step5" forKey:@"name"];
    rightAnima.delegate = self;
    [self.rightAppearLayer addAnimation:rightAnima forKey:nil];
}

- (void)step6{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * 1000 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self prepareForStep6Success];;
        [self processStep6SuccessA];
        [self processStep6SuccessB];
    });
}


- (void)prepareForStep6Success {
    [self.fallThickLayer removeFromSuperlayer];
    [self.moveArcLayer removeFromSuperlayer];
    [self.leftAppearLayer removeFromSuperlayer];
    [self.rightAppearLayer removeFromSuperlayer];
}

// 圆变色
- (void)processStep6SuccessA {
    self.loadingCircleLayer.lineColor = self.likeGreenColor;
}

// 对号出现
- (void)processStep6SuccessB {
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))/2.0 - kLineWidth/ 2.0;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    
    self.checkMarkLayer = [CAShapeLayer layer];
    self.checkMarkLayer.frame = self.bounds;
    [self.layer addSublayer:self.checkMarkLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint firstPoint = centerPoint;
    firstPoint.x -= radius / 2;
    [path moveToPoint:firstPoint];
    CGPoint secondPoint = centerPoint;
    secondPoint.x -= radius / 8;
    secondPoint.y += radius / 2;
    [path addLineToPoint:secondPoint];
    CGPoint thirdPoint = centerPoint;
    thirdPoint.x += radius / 2;
    thirdPoint.y -= radius / 2;
    [path addLineToPoint:thirdPoint];
    
    self.checkMarkLayer.path = path.CGPath;
    self.checkMarkLayer.lineWidth = 6;
    self.checkMarkLayer.strokeColor = self.likeGreenColor.CGColor;
    self.checkMarkLayer.fillColor = nil;
    
    // end status
    CGFloat strokeEnd = 1;
    self.checkMarkLayer.strokeEnd = strokeEnd;
    
    // animation
    CABasicAnimation *step6bAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    step6bAnimation.duration = 1;
    step6bAnimation.fromValue = @0;
    step6bAnimation.toValue = @(strokeEnd);
    [step6bAnimation setValue:@"step6" forKey:@"name"];
    step6bAnimation.delegate = self;
    [self.checkMarkLayer addAnimation:step6bAnimation forKey:nil];
}


#pragma mark -CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *name = [anim valueForKey:@"name"];
    if ([name isEqualToString:@"step1"]) {
        [self step2];
    }else if ([name isEqualToString:@"step2"]) {
        [self step3];
    }else if ([name isEqualToString:@"step3"]) {
        [self step4];
    }else if ([name isEqualToString:@"step4"]) {
        [self step5];
    }else if ([name isEqualToString:@"step5"]) {
        [self step6];
    }else if ([name isEqualToString:@"step6"]) {
        self.animationing = NO;
    }
    
}
@end
