//
//  UIScrollView+Moving.m
//  Lottery
//
//  Created by SGQ on 2018/4/25.
//  Copyright © 2018年 9188.com. All rights reserved.
//

#import "UIScrollView+Moving.h"
#import <objc/runtime.h>

static const char _isMovingKey;

@implementation UIScrollView (Moving)

- (BOOL)isMoving
{
    return [objc_getAssociatedObject(self, &_isMovingKey) boolValue];
}

- (void)setIsMoving:(BOOL)isMoving
{
     objc_setAssociatedObject(self, &_isMovingKey, @(isMoving),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
