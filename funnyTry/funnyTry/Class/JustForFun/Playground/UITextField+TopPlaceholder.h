//
//  UITextField+TopPlaceholder.h
//  funnyTry
//
//  Created by SGQ on 2018/8/30.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (TopPlaceholder)

@property (nonatomic, strong) UILabel *topPlaceholerLabel;
@property (nonatomic, strong) UIFont *topPlaceholerFont;

- (void)enableTopPlaceholder;

@end
