//
//  IQiYIButton.h
//  funnyTry
//
//  Created by SGQ on 2017/12/14.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,IQiYIButtonState){
    IQiYIButtonStatePause,
    IQiYIButtonStatePlay,
};

@interface IQiYIButton : UIButton

/**
 * 设置buttom状态
 */
@property (nonatomic, assign) IQiYIButtonState playState;

- (instancetype)initWithFrame:(CGRect)frame playState:(IQiYIButtonState)playState;

@end
