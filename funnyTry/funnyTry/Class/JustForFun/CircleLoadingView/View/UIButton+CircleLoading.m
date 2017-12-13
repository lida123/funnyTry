//
//  UIButton+CircleLoading.m
//  funnyTry
//
//  Created by SGQ on 2017/11/16.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "UIButton+CircleLoading.h"
#import <objc/runtime.h>

static const void * loadingViewKey = &loadingViewKey;

@implementation UIButton (CircleLoading)

- (FTCircleLoadingView *)cl_loadingView {
    return objc_getAssociatedObject(self, loadingViewKey);
}

- (void)setCl_loadingView:(FTCircleLoadingView *)cl_loadingView {
    objc_setAssociatedObject(self, loadingViewKey, cl_loadingView, OBJC_ASSOCIATION_RETAIN);
}

- (void)cl_setLayerColor:(UIColor *)layerColor {
    FTCircleLoadingView *loadingView = [self cl_loadingView];
    if (!loadingView) {
        loadingView  = [[FTCircleLoadingView alloc] initWithFrame:CGRectZero];
        [self setCl_loadingView:loadingView];
        [self addSubview:loadingView];
    }
    loadingView.layerColor = layerColor;
}

- (void)cl_setLayerWidth:(CGFloat)layerWidth {
    FTCircleLoadingView *loadingView = [self cl_loadingView];
    if (!loadingView) {
        loadingView  = [[FTCircleLoadingView alloc] initWithFrame:CGRectZero];
        [self setCl_loadingView:loadingView];
        [self addSubview:loadingView];
    }
    loadingView.layerWidth = layerWidth;
}


- (void)cl_startLoading {
    FTCircleLoadingView *loadingView = [self cl_loadingView];
    if (!loadingView) {
        loadingView  = [[FTCircleLoadingView alloc] initWithFrame:CGRectZero];
        [self setCl_loadingView:loadingView];
        [self addSubview:loadingView];
    }
    loadingView.hidden = NO;
    loadingView.frame = [self loadingViewFrame];
    [loadingView startLoading];
    self.userInteractionEnabled = NO;
}

- (void)cl_endLoadingSucceedWithEndBlock:(void (^)(void))endBlock{
    FTCircleLoadingView *loadingView = [self cl_loadingView];
    if (!loadingView) {
        loadingView  = [[FTCircleLoadingView alloc] initWithFrame:CGRectZero];
        [self setCl_loadingView:loadingView];
        [self addSubview:loadingView];
    }
    __weak typeof(loadingView) weakLoadingView = loadingView;
    __weak typeof (self) weakself = self;
    loadingView.frame = [self loadingViewFrame];
    loadingView.endBlock = ^{
        weakLoadingView.hidden = YES;
        endBlock();
        weakself.userInteractionEnabled = YES;
    };;
    [loadingView endLoadingSucceed];
}

- (CGRect)loadingViewFrame  {
    CGFloat h = CGRectGetHeight(self.bounds) * 0.5;
    CGFloat w = h;
    UIFont *font = self.titleLabel.font;
    NSString *text = [self titleForState:UIControlStateNormal];
    CGRect titleBounds = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    titleBounds.origin.x = (self.bounds.size.width - titleBounds.size.width) / 2.0;
    CGFloat x = titleBounds.origin.x - w - 8;
    CGFloat y = (CGRectGetHeight(self.bounds) - h ) / 2.0;
    return CGRectMake(x, y, w, h);
}

@end
