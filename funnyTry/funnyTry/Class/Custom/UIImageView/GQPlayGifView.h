//
//  GQPlayGifView.h
//  UIImage+Categories
//
//  Created by SGQ on 17/1/13.
//  Copyright © 2017年 lisong. All rights reserved.
//

/**
 * 使用CAKeyframeAnimation改变layer.contents确保每一帧图片和时间对上号.但是内存占得多.FLAnimatedImageView完美解决了这个问题
 */
#import <UIKit/UIKit.h>

@interface GQPlayGifView : UIImageView <CAAnimationDelegate>

// gif资源的url,此方法后,返回的view bounds为gif图片的大小,再设置位置即可.
- (instancetype)initWithUr:(NSURL*)url;

// gif Data,此方法后,返回的view bounds为gif图片的大小,再设置位置即可.
- (instancetype)initWithGifData:(NSData*)gifData;

// 开始播放
- (void)startPlayGif;

// 停止
- (void)stopPalyGif;

// 暂停
- (void)pauseGif;

// 暂停后 继续
- (void)restartGif;

@end
