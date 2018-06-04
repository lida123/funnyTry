//
//  UIImage+Function.m
//  学习之路
//
//  Created by SGQ on 16/12/7.
//  Copyright © 2016年 GQ. All rights reserved.
//

#import "UIImage+Function.h"

@implementation UIImage (Function)

// 将图片旋转任意角度
- (UIImage*)newImageWithRotatedAngle:(CGFloat)angel{
    // 旋转一个矩形view后,如果不是旋转90度的倍数,它的frame会变大,这个大小才是画板的大小
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    rotatedViewBox.transform = CGAffineTransformMakeRotation(angel * M_PI / 180.0);
    CGSize rotatedSize = rotatedViewBox.frame.size;

    // Create the bitmap context
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, 0);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // 平移后bitmap的原点是刚开始的中心位置
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // 旋转
    CGContextRotateCTM(bitmap,angel * M_PI / 180.0);
    
    // 画图片 因为最终获取图片还是从初始状态的位图获取图片,所以画的时候,根据变化的bitmap位置进行偏移
    [self drawInRect: CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height)];
    
    // 如果不是旋转90度的倍数 获取的图片大小虽然跟原始图片一样,但是因为是歪的,所以图片会是空白部分加上缩小的原图片组成的(好比要把一张图片放进一个一样大小的相框中,如果图片摆得是正的,可以放进去,如果不是正的,那只能将图片按比例缩小,图片的四个顶点顶在相框的四条边上)
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 旋转后为了保证新图片和原图片一样大,控件的size
- (CGSize)newImageSizeWithRotatedAngle:(CGFloat)angel {
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    rotatedViewBox.transform = CGAffineTransformMakeRotation(angel * M_PI / 180.0);
    return rotatedViewBox.frame.size;
}

// 获取图片某点的颜色
-(UIColor *)colorAtPoint:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0, 0, self.size.width, self.size.height), point)) {
        return nil;
    }
    
    CGFloat pointX = truncf(point.x);
    CGFloat pointY = truncf(point.y);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    unsigned char pixelData[4];
    CGContextRef context =  CGBitmapContextCreate(&pixelData, 1, 1, 8, 4, colorSpaceRef, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -pointX, pointY - self.size.height);
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGFloat r = pixelData[0]/255.0;
    CGFloat g = pixelData[1]/255.0;
    CGFloat b = pixelData[2]/255.0;
    CGFloat a = pixelData[3]/255.0;
    UIColor * color = [UIColor colorWithRed:r green:g blue:b alpha:a];
    CGContextRelease(context);
    return color;
}

// 获得灰度图
- (UIImage *)convertToGrayImage {
    int w = self.size.width;
    int h = self.size.height;
    CGColorSpaceRef grayColorSpace =  CGColorSpaceCreateDeviceGray();
    CGContextRef context =  CGBitmapContextCreate(NULL, w, h, 8, 0, grayColorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(grayColorSpace);
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    return [UIImage imageWithCGImage:imageRef];
}
@end
