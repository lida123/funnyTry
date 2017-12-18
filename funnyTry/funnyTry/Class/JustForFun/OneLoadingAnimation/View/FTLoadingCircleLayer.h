//
//  FTLoadingCircleLayer.h
//  funnyTry
//
//  Created by SGQ on 2017/12/18.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface FTLoadingCircleLayer : CALayer

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat progress;

@end
