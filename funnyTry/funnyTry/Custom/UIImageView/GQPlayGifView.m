//
//  GQPlayGifView.m
//  UIImage+Categories
//
//  Created by SGQ on 17/1/13.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import "GQPlayGifView.h"
#import <ImageIO/ImageIO.h>

static NSString * const GQGifAnimationKey = @"GQGifAnimationKey";

@implementation GQPlayGifView {
    NSMutableArray * _frames;
    NSMutableArray * _framesDelayTimes;
    CGFloat _totalTime;
    CGFloat _gifWidth;
    CGFloat _gifHeight;
}

static void getFrameInfo(CGImageSourceRef CF_RELEASES_ARGUMENT source, NSMutableArray *frames, NSMutableArray *framesDelayTimes, CGFloat *totalTime, CGFloat *gifWidth, CGFloat *gifHeight) {
    if (source == NULL || frames == NULL || framesDelayTimes == NULL || totalTime == NULL || gifWidth == NULL || gifWidth == NULL) { return; }
    
    size_t imageCount = CGImageSourceGetCount(source);
    for (NSInteger i = 0; i < imageCount; i++) {
        CGImageRef frame = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (frame) {
            [frames addObject:(__bridge id _Nonnull)(frame)];
        }
        
        CFDictionaryRef sourcePropertyRef = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        CFDictionaryRef gifPropertyRef = CFDictionaryGetValue(sourcePropertyRef, kCGImagePropertyGIFDictionary);
        
        CFTypeRef width = CFDictionaryGetValue(sourcePropertyRef, kCGImagePropertyPixelWidth);
        if (width) {
            CFNumberGetValue(width, kCFNumberLongType, gifWidth);
        }
        
        CFTypeRef height = CFDictionaryGetValue(sourcePropertyRef, kCGImagePropertyPixelHeight);
        if (height) {
            CFNumberGetValue(height, kCFNumberLongType, gifWidth);
        }
        
        if (gifPropertyRef) {
            NSString* time = (NSString*)CFDictionaryGetValue(gifPropertyRef, kCGImagePropertyGIFDelayTime);
            if (time.floatValue > 0) {
                NSLog(@"%@",time);
                [framesDelayTimes addObject:time];
                *totalTime = *totalTime + time.floatValue;
            }
        }
        CGImageRelease(frame);
        CFRelease(sourcePropertyRef);
    }
    CFRelease(source);
}

- (instancetype)initWithUr:(NSURL*)url {
    if (self = [super initWithFrame:CGRectZero]) {
        _frames = [NSMutableArray array];
        _framesDelayTimes = [NSMutableArray array];
        // 填充属性
        getFrameInfo(CGImageSourceCreateWithURL((CFURLRef)url, NULL), _frames, _framesDelayTimes, &_totalTime, &_gifWidth, &_gifHeight);
        self.bounds = CGRectMake(0, 0, _gifWidth, _gifHeight);
    }
    return self;
}

- (instancetype)initWithGifData:(NSData *)gifData {
    if (self = [super initWithFrame:CGRectZero]) {
        _frames = [NSMutableArray array];
        _framesDelayTimes = [NSMutableArray array];
        // 填充属性
        getFrameInfo(CGImageSourceCreateWithData((CFDataRef)gifData, NULL), _frames, _framesDelayTimes, &_totalTime, &_gifWidth, &_gifHeight);
        self.bounds = CGRectMake(0, 0, _gifWidth, _gifHeight);
    }
    return self;
}

- (void)startPlayGif {
    [self.layer removeAnimationForKey:GQGifAnimationKey];
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    NSMutableArray * times = [NSMutableArray array];
    CGFloat currentTime = 0;
    for (NSInteger i = 0; i < _framesDelayTimes.count; i++) {
        [times addObject:@(currentTime / _totalTime)];
        currentTime += [_framesDelayTimes[i] floatValue];
    }
    [animation setKeyTimes:times];
    
    NSMutableArray * images = [NSMutableArray array];
    for (NSInteger i = 0; i < _framesDelayTimes.count; i++) {
        [images addObject:_frames[i]];
    }
    [animation setValues:images];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = _totalTime;
    animation.repeatCount = MAXFLOAT;
    animation.delegate = self;
    [self.layer addAnimation:animation forKey:GQGifAnimationKey];
}

- (void)stopPalyGif {
    [self.layer removeAnimationForKey:GQGifAnimationKey];
}

- (void)pauseGif {
    [self pauseLayer:self.layer];
}

-(void)restartGif {
    [self resumeLayer:self.layer];
}

// 暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer {
    if (self.layer.speed == 0.0) {
        return;
    }
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

// 继续layer上面的动画
-(void)resumeLayer:(CALayer*)layer {
    if (self.layer !=0) {
        return;
    }
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.layer.contents = nil;
}
@end
