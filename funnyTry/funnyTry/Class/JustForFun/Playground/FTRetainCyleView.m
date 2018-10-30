//
//  FTRetainCyleView.m
//  funnyTry
//
//  Created by SGQ on 2018/10/25.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTRetainCyleView.h"

@implementation FTRetainCyleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.myBlock = ^{
            self.backgroundColor = [UIColor grayColor];
        };
    }
    return self;
}


- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.myBlock = nil;
    });
}



@end
