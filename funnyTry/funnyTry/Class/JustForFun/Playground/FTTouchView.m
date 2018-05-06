//
//  FTTouchView.m
//  funnyTry
//
//  Created by SGQ on 2018/4/20.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTTouchView.h"
#import "UIScrollView+Moving.h"

@interface FTTouchView ()
@property (nonatomic, weak) UIScrollView *srollView;
@end

@implementation FTTouchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.normalColor = [UIColor whiteColor];
        self.touchedColor = [UIColor grayColor];
    }
    return self;
}


- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.backgroundColor = normalColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s isMoving:%@",__func__,self.srollView.isMoving?@"YES":@"NO");
    
    if (self.srollView.isMoving || self.srollView.contentOffset.y < 0 - self.srollView.contentInset.top || self.srollView.contentOffset.y > self.srollView.contentSize.height - self.srollView.height + self.srollView.contentInset.bottom) {
        return;
    }
    
    [self setBackgroundToTouchedColor];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    [self setBackgroundToNormalColorImmediately:NO];
    self.touchBlock?self.touchBlock():nil;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    [self setBackgroundToNormalColorImmediately:YES];
}

- (void)setBackgroundToTouchedColor
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setBackgroundColor:) object:self.normalColor];
    self.backgroundColor = self.touchedColor;
}

- (void)setBackgroundToNormalColorImmediately:(BOOL)immediately
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setBackgroundColor:) object:self.normalColor];
    if (immediately) {
        self.backgroundColor = self.normalColor;
    } else {
        [self performSelector:@selector(setBackgroundColor:) withObject:self.normalColor afterDelay:0.4 inModes:@[NSRunLoopCommonModes]];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
