//
//  FTLoadingCircleLayer.m
//  funnyTry
//
//  Created by SGQ on 2017/12/18.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTLoadingCircleLayer.h"

@implementation FTLoadingCircleLayer
@dynamic progress;
@dynamic lineColor;
@dynamic lineWidth;

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else if ([key isEqualToString:@"lineColor"]) {
        return YES;
    } else if ([key isEqualToString:@"lineWidth"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2 - self.lineWidth / 2;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

    // O
    CGFloat originStart = M_PI * 7 / 2;
    CGFloat originEnd = M_PI * 2;
    CGFloat currentOrigin = originStart - (originStart - originEnd) * self.progress;

    // D
    CGFloat destStart = M_PI * 3;
    CGFloat destEnd = 0;
    CGFloat currentDest = destStart - (destStart - destEnd) * self.progress;

    CGContextAddArc(ctx, center.x, center.y, radius, currentOrigin, currentDest, YES);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextStrokePath(ctx);
}
@end
