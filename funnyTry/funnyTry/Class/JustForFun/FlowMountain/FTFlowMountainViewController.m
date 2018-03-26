//
//  FTFlowMountainViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/9.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTFlowMountainViewController.h"
// 将常数转换为度数
#define   DEGREES(degrees)  ((M_PI * (degrees))/ 180.f)

@interface FTFlowMountainViewController ()

@end

@implementation FTFlowMountainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"波动山峰";
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds))];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.center = self.view.center;
    [self.view addSubview:blackView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = blackView.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gradientLayer.locations = @[@(-0.2), @(-0.1), @(0)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [blackView.layer addSublayer:gradientLayer];
    
    CAShapeLayer *mountainLayer = [self mountainLayerInRect:blackView.bounds layerPoint:CGPointMake(0, CGRectGetWidth(blackView.frame) / 2.0)];
    /* 随便设置一个颜色 */
    mountainLayer.strokeColor = [UIColor blackColor].CGColor;
    gradientLayer.mask = mountainLayer;
    [self.view.layer addSublayer:gradientLayer];
    
    /* 添加动画 */
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
    fadeAnim.fromValue = @[@(-0.2), @(-0.1), @(0)];
    fadeAnim.toValue   = @[@(1.0), @(1.1), @(1.2)];
    fadeAnim.duration  = 1.5;
    fadeAnim.repeatCount = MAXFLOAT;
    [gradientLayer addAnimation:fadeAnim forKey:nil];
}

- (CAShapeLayer *)mountainLayerInRect:(CGRect)rect layerPoint:(CGPoint)point{
    CAShapeLayer *layer = [CAShapeLayer layer];

    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    [path moveToPoint:CGPointMake(0, h * 0.5)];
    [path addLineToPoint:CGPointMake(w * 0.3, h  * 0.5)];
    [path addLineToPoint:CGPointMake(w * 0.35, h  * 0.1)];
    [path addLineToPoint:CGPointMake(w * 0.4, h * 0.5)];
    [path addLineToPoint:CGPointMake(w, h * 0.5)];
    
    // 获取path
    layer.path = path.CGPath;
    layer.position = point;
    
    // 设置填充颜色为透明
    layer.fillColor = [UIColor clearColor].CGColor;
    
    return layer;
}
@end

/* mask 原理
 // 创建UILabel
 UILabel *label = [[YZLabel alloc] init];
 label.text = @"小码哥,专注于高级iOS开发工程师的培养";
 [label sizeToFit];
 label.center = CGPointMake(200, 100);
 // 疑问：label只是用来做文字裁剪，能否不添加到view上。
 // 必须要把Label添加到view上，如果不添加到view上，label的图层就不会调用drawRect方法绘制文字，也就没有文字裁剪了。
 // 如何验证，自定义Label,重写drawRect方法，看是否调用,发现不添加上去，就不会调用
 [self.view addSubview:label];
 // 创建渐变层
 CAGradientLayer *gradientLayer = [CAGradientLayer layer];
 gradientLayer.frame = label.frame;
 // 设置渐变层的颜色，随机颜色渐变
 gradientLayer.colors = @[(id)[self randomColor].CGColor, (id)[self randomColor].CGColor,(id)[self randomColor].CGColor];
 // 疑问:渐变层能不能加在label上
 // 不能，mask原理：默认会显示mask层底部的内容，如果渐变层放在mask层上，就不会显示了
 // 添加渐变层到控制器的view图层上
 [self.view.layer addSublayer:gradientLayer];
 // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
 // 设置渐变层的裁剪层
 gradientLayer.mask = label.layer;
 // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层，这样做的目的：以渐变层为坐标系，方便计算裁剪区域，如果以其他层为坐标系，还需要做点的转换，需要把别的坐标系上的点，转换成自己坐标系上点，判断当前点在不在裁剪范围内，比较麻烦。
 // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
 label.frame = gradientLayer.bounds;
 // 利用定时器，快速的切换渐变颜色，就有文字颜色变化效果
 CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(textColorChange)];
 [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
 // 随机颜色方法
 -(UIColor *)randomColor{
 CGFloat r = arc4random_uniform(256) / 255.0;
 CGFloat g = arc4random_uniform(256) / 255.0;
 CGFloat b = arc4random_uniform(256) / 255.0;
 return [UIColor colorWithRed:r green:g blue:b alpha:1];
 }
 // 定时器触发方法
 -(void)textColorChange {
 _gradientLayer.colors = @[(id)[self randomColor].CGColor,
 (id)[self randomColor].CGColor,
 (id)[self randomColor].CGColor,
 (id)[self randomColor].CGColor,
 (id)[self randomColor].CGColor];
 }
 
 */
