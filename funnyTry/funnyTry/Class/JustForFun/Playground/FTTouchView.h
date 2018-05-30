//
//  FTTouchView.h
//  funnyTry
//
//  Created by SGQ on 2018/4/20.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTTouchView : UIView

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *touchedColor;
@property (nonatomic, copy) void (^touchBlock)(void);

@end
