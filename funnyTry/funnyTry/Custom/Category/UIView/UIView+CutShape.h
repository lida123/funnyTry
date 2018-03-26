//
//  UIView+CutShape.h
//  funnyTry
//
//  Created by SGQ on 2017/11/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

UIBezierPath * cutCorner(CGRect originalFrame,CGFloat length);

@interface UIView (CutShape)

- (void)setShape:(CGPathRef)shape;

@end
