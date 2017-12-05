//
//  FTGlobal.m
//  funnyTry
//
//  Created by SGQ on 2017/12/5.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTGlobal.h"

void FTShowImageOnWindow(UIImage*image) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = window.center;
    [window addSubview:imageView];
}
