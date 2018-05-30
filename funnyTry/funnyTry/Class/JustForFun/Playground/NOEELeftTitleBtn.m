//
//  NOEELeftTitleBtn.m
//  Lottery
//
//  Created by SGQ on 17/3/22.
//  Copyright © 2017年 9188-MacPro1. All rights reserved.
//

#import "NOEELeftTitleBtn.h"

@implementation NOEELeftTitleBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        _titleLeftMargin = 0;
        _title_image_space = 5;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
     CGRect r_image = [super imageRectForContentRect:contentRect];
     CGRect r_title = [self titleRectForContentRect:contentRect];
    return CGRectMake(CGRectGetMaxX(r_title) + _title_image_space, r_image.origin.y, r_image.size.width, r_image.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect r_title = [super titleRectForContentRect:contentRect];
    return CGRectMake(_titleLeftMargin,r_title.origin.y, r_title.size.width,r_title.size.height);
}
//CodeBlockReplacementABCDEFG
@end
