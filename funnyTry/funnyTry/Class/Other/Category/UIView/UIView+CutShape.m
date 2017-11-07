//
//  UIView+CutShape.m
//  funnyTry
//
//  Created by SGQ on 2017/11/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "UIView+CutShape.h"

UIBezierPath * cutCorner(CGRect originalFrame,CGFloat length)
{
    CGRect rect = originalFrame;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(0, length)];
    [bezierPath addLineToPoint:CGPointMake(length, 0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width - length, 0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, length)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height - length)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width - length, rect.size.height)];
    [bezierPath addLineToPoint:CGPointMake(length, rect.size.height)];
    [bezierPath addLineToPoint:CGPointMake(0, rect.size.height - length)];
    [bezierPath closePath];
    return bezierPath;
}

@implementation UIView (CutShape)

- (void)setShape:(CGPathRef)shape{
    if (shape == nil) {
        self.layer.mask = nil;
    }
    
    CAShapeLayer* maskLayer = [CAShapeLayer layer];
    maskLayer.path = shape;
    self.layer.mask = maskLayer;
}

@end
