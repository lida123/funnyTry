//
//  YouKuPlayButton.h
//  funnyTry
//
//  Created by SGQ on 2017/12/14.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,YouKuButtonState){
    YouKuButtonStatePause,
    YouKuButtonStatePlay,
};

@interface YouKuPlayButton : UIButton

/**
 * 设置buttom状态
 */
@property (nonatomic, assign) YouKuButtonState playState;

- (instancetype)initWithFrame:(CGRect)frame playState:(YouKuButtonState)playState;

@end
