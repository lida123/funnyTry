//
//  FTWaterView.m
//  funnyTry
//
//  Created by SGQ on 2018/9/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTWaterView.h"

@implementation FTWaterView {
    __weak  CADisplayLink *_link;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self.superLayer setNeedsDisplay];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGFloat startX = self.bounds.size.width * self.progress;
    CGFloat height = 20;
    CGFloat width = 20;
//    CGFloat endX = startX + width;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(startX, 0, width, height) cornerRadius:10];
    CGContextAddPath(ctx, path.CGPath);
//    CGContextAddRect(ctx, CGRectMake(startX, 0, width, height));
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillPath(ctx);
    
//    CGFloat startX = 50;
//    CGFloat height = 50;
//    CGFloat width = 50;
//    CGFloat endX = 100;
//    CGContextMoveToPoint(ctx, startX, height);
//    CGContextAddLineToPoint(ctx, endX, height);
//    CGContextAddLineToPoint(ctx, startX + width / 2.0, 0);
//    CGContextClosePath(ctx);
//    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
//    CGContextFillPath(ctx);
}

- (void)startAnimation {
    if (_link) {
        [_link invalidate];
    }
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(progressChanged)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}

- (void)progressChanged {
    CGFloat progress = self.progress;
    progress += 0.01;
    if (progress >= 1) {
        progress = 0;
    }
    self.progress = progress;
}
@end
