//
//  GQPlayGifView.h
//  UIImage+Categories
//
//  Created by SGQ on 17/1/13.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQPlayGifView : UIView <CAAnimationDelegate>

// gif资源的url,此方法后,返回的view bounds为gif图片的大小,再设置位置即可.
- (instancetype)initWithUr:(NSURL*)url;

// gif Data,此方法后,返回的view bounds为gif图片的大小,再设置位置即可.
- (instancetype)initWithGifData:(NSData*)gifData;

// 开始播放
- (void)startPlayGif;

// 停止
- (void)removeGif;

// 暂停
- (void)pauseGif;

// 暂停后 继续
- (void)restartGif;

@end
