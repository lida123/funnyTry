//
//  FTCircleLoadingView.m
//  funnyTry
//
//  Created by SGQ on 2017/11/16.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCircleLoadingView.h"

static CGFloat const loadingCircleDuriation = 1.2;
static CGFloat const successCircleDuriation = 0.5f;
static CGFloat const successcheckDuration = 0.2f;

static CABasicAnimation *loadingView_animation(CFTimeInterval duration,id delegate) {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = duration;
    animation.delegate = delegate;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

@interface FTCircleLoadingView()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *tickLayer;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) BOOL isExecutingSuccessAnim;
@end

@implementation FTCircleLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _layerColor = FT_RGBCOLOR(16, 142, 233);
        _layerWidth = 2.0;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self endCircleAnimation];
    }
}

- (void)startLoading {
    if (self.isExecutingSuccessAnim) {
        return;
    }
    if (_tickLayer && _tickLayer.superlayer ) {
        [_tickLayer removeFromSuperlayer];
        _tickLayer = nil;
    }
    
    [self setUpCircleLayerPropety:self.circleLayer];
    self.link.paused = NO;
}

- (void)endLoadingSucceed {
    if (self.isExecutingSuccessAnim) {
        return;
    }
    self.isExecutingSuccessAnim = YES;
    [self endCircleAnimation];
    
    [self successCircleAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * successCircleDuriation * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self successTickAnimation];
    });
}

// 归零
- (void)endCircleAnimation {
    [self.link invalidate];
    self.link = nil;
    _startAngle = 0;
    _endAngle = 0;
    _progress = 0;
}

- (void)setUpCircleLayerPropety:(CAShapeLayer *)layer {
    layer.strokeColor = _layerColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = self.layerWidth;
    layer.lineCap = kCALineCapRound;
    layer.frame = self.bounds;
}

// 更新progress
- (void)updateProgress {
    self.progress += [self perProgress];
    if (self.progress >= 0.75) {
        
    }
    if (self.progress >= 1) {
        self.progress = 0;
    }
    [self redrawCircleLayer];
}

// 重新绘制circelLayer
-(void)redrawCircleLayer{
    self.startAngle = -M_PI_2;
    self.endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    
    CGFloat r = w/2.0f - self.layerWidth/2.0f;
    CGFloat centerX = w/2.0f;
    CGFloat centerY = h/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:r startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    self.circleLayer.path = path.CGPath;
}

// 单次的progress
-(CGFloat)perProgress{
    // 前半动画占用 1/3 duration  后半动画占用 2/3 duration
    CGFloat perDuration = loadingCircleDuriation/3.0;
    CGFloat sufDuration = loadingCircleDuriation * 2/3.0;
    
    if (self.endAngle > M_PI) {
        return (1/4.0)/(sufDuration * 60);
    }else {
      return (3/4.0)/(perDuration * 60);
    }
    
}

// 成功circleLayer动画
- (void)successCircleAnimation {
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat r = w/2.0f - self.layerWidth/2.0f;
    CGFloat centerX = w/2.0f;
    CGFloat centerY = h/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:r startAngle:-M_PI/2 endAngle:M_PI*3/2 clockwise:YES];
    self.circleLayer.path = path.CGPath;
    [self setUpCircleLayerPropety:self.circleLayer];
    [self.circleLayer addAnimation:loadingView_animation(successCircleDuriation, nil) forKey:@"successCircleAnimationKey"];
}

// 成功tickLayer动画
- (void)successTickAnimation {
    CGFloat w = CGRectGetWidth(self.bounds);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(w*2.7/10,w*5.4/10)];
    [path addLineToPoint:CGPointMake(w*4.5/10,w*7/10)];
    [path addLineToPoint:CGPointMake(w*7.8/10,w*3.8/10)];
    self.tickLayer.path = path.CGPath;
    [self setUpCircleLayerPropety:self.tickLayer];
    [self.tickLayer addAnimation:loadingView_animation(successcheckDuration, self) forKey:@"successTickAnimationKey"];
}

#pragma mark - lazy initialize
- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}

- (CAShapeLayer *)tickLayer {
    if (!_tickLayer) {
        _tickLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_tickLayer];
    }
    return _tickLayer;
}

- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
        _link.paused = YES;
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _link;
}

/* 圆圈的路径 */
- (UIBezierPath*)circleBesierPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = self.bounds;
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2) radius:[self circleRadius] startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
    return path;
}
/* 对勾的路径 */
- (UIBezierPath*)tickBesierPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = self.bounds;
    
    CGPoint point1 = CGPointMake(rect.size.width * 0.38  , rect.size.height * 0.5);
    CGPoint point2 = CGPointMake(rect.size.width * 0.5  , rect.size.height * 0.6);
    CGPoint point3 = CGPointMake(rect.size.width * 0.72  , rect.size.height * 0.36);
    
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    
    return path;
}

- (CGFloat)circleRadius{
    return CGRectGetWidth(self.bounds)/2;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag; {
    if (flag && self.endBlock) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.circleLayer removeFromSuperlayer];
            self.circleLayer = nil;
            
            [self.tickLayer removeFromSuperlayer];
            self.tickLayer = nil;
            
            self.endBlock();
            self.isExecutingSuccessAnim = NO;
        });
    }
}

- (void)dealloc {
    FTDPRINT(@"");
}
@end
