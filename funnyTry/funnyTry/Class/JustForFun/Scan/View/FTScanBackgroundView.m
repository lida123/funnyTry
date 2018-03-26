//
//  FTScanBackgroundView.m
//  funnyTry
//
//  Created by SGQ on 2017/11/10.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTScanBackgroundView.h"

@interface FTScanBackgroundView()
@property (nonatomic, strong) UIImageView *imageV0;
@property (nonatomic, strong) UIImageView *imageV1;
@property (nonatomic, strong) UIImageView *imageV2;
@property (nonatomic, strong) UIImageView *imageV3;
@property (nonatomic, strong) UIView *topLayerView;
@property (nonatomic, strong) UIView *leftLayerView;
@property (nonatomic, strong) UIView *bottomLayerView;
@property (nonatomic, strong) UIView *rightLayerView;
@end

@implementation FTScanBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIColor *layerColor = FT_RGBCOLOR(180, 180, 180);
        
        _topLayerView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLayerView.backgroundColor = layerColor;
        [self addSubview:_topLayerView];
        
        _leftLayerView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftLayerView.backgroundColor = layerColor;
        [self addSubview:_leftLayerView];
        
        _bottomLayerView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLayerView.backgroundColor = layerColor;
        [self addSubview:_bottomLayerView];
        
        _rightLayerView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightLayerView.backgroundColor = layerColor;
        [self addSubview:_rightLayerView];
        
        
        _imageV0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR1"]];
        [self addSubview:_imageV0];
        
        _imageV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR2"]];
        [self addSubview:_imageV1];
        
        _imageV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR3"]];
        [self addSubview:_imageV2];
        
        _imageV3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR4"]];
        [self addSubview:_imageV3];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageV0.frame = CGRectMake(0, 0, self.imageV0.image.size.width, self.imageV0.image.size.height);
    self.imageV1.frame = CGRectMake(CGRectGetWidth(self.bounds) - self.imageV1.image.size.width, 0, self.imageV1.image.size.width, self.imageV1.image.size.height);
    self.imageV2.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - self.imageV2.image.size.height, self.imageV2.image.size.width, self.imageV2.image.size.height);
    self.imageV3.frame = CGRectMake(CGRectGetWidth(self.bounds) - self.imageV3.image.size.width, CGRectGetHeight(self.bounds) - self.imageV3.image.size.height, self.imageV3.image.size.width, self.imageV3.image.size.height);
    CGFloat w = 1;
    CGSize size = self.bounds.size;
    self.topLayerView.frame = CGRectMake(0, 0, size.width, w);
    self.leftLayerView.frame = CGRectMake(0, 0, w, size.height);
    self.bottomLayerView.frame = CGRectMake(0, size.height - w, size.width, w);
    self.rightLayerView.frame = CGRectMake(size.width - w, 0, w, size.height);
}

@end
