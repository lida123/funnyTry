//
//  UIView+Screenshot.m
//  Lottery
//
//  Created by huangshouwu on 14-2-25.
//  Copyright (c) 2014年 9188-MacPro1. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

-(UIImage *)convertViewToImage
{
    return [self convertViewToImageWithFrame:self.bounds];
}

- (UIImage *)convertViewToImageWithFrame:(CGRect)rect{
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)drawImage:(UIImage *)image InRect:(CGRect)rect{
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image2 = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    
    [image2 drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    [image drawInRect:CGRectMake(0, self.bounds.size.height - 90 * CGRectGetWidth(FTScreenBounds) / 375, self.bounds.size.width, 90 * CGRectGetWidth(FTScreenBounds) / 375)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// 拼接二维码
- (UIImage *)drawImage:(UIImage *)codeImage inImage:(UIImage *)image
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat codeImageH = 90 * CGRectGetWidth(FTScreenBounds) / 375;
    
    CGSize allSize = CGSizeMake(image.size.width, image.size.height - 85 - 5 + codeImageH - 8);  // 5 是footer  8是header 高度
    
    UIGraphicsBeginImageContextWithOptions(allSize, NO, scale);
    
    [image drawInRect:CGRectMake(0, -8, allSize.width, image.size.height)];
    [codeImage drawInRect:CGRectMake(0, allSize.height - codeImageH, allSize.width, codeImageH)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}


// 截取整个tableView
- (UIImage *)imageFromTableView:(UITableView *)tableView
{
    // 截取tableView的图片
    CGSize size = tableView.contentSize;
    CGPoint savedContentOffset = tableView.contentOffset;
    CGRect saveFrame = tableView.frame;
    
    tableView.contentOffset = CGPointZero;
    tableView.frame = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    [tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *tableViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 恢复原状态
    tableView.contentOffset = savedContentOffset;
    tableView.frame = saveFrame;
    
    return tableViewImage;
}

@end
