//
//  UIView+Screenshot.h
//  Lottery
//
//  Created by huangshouwu on 14-2-25.
//  Copyright (c) 2014年 9188-MacPro1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

-(UIImage *)convertViewToImage;
- (UIImage *)convertViewToImageWithFrame:(CGRect)rect;
- (UIImage *)drawImage:(UIImage *)image InRect:(CGRect)rect;

// 拼接二维码
- (UIImage *)drawImage:(UIImage *)codeImage inImage:(UIImage *)image;

// 截取整个tableView
- (UIImage *)imageFromTableView:(UITableView *)tableView;
@end
