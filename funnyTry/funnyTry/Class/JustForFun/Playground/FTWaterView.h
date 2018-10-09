//
//  FTWaterView.h
//  funnyTry
//
//  Created by SGQ on 2018/9/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTWaterView : UIView <CALayerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CALayer *superLayer;

- (void)startAnimation;
@end
