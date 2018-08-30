//
//  UITextField+TopPlaceholder.m
//  funnyTry
//
//  Created by SGQ on 2018/8/30.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "UITextField+TopPlaceholder.h"
#import <objc/runtime.h>

@implementation UITextField (TopPlaceholder)

#pragma mark - Public
- (void)enableTopPlaceholder {
    [self addTarget:self action:@selector(tp_beginEditing) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(tp_endEditing) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - UIControlEventEditingDidBegin
- (void)tp_beginEditing {
    if (!self.placeholder.length || self.text.length > 0) {
        return;
    }
    
    [self topPlaceholerLabelStartMoveToTop];
    
    UILabel *tp_label = self.topPlaceholerLabel;
    CGFloat scale = self.topPlaceholerFont.pointSize / tp_label.font.pointSize;
    CGPoint center = CGPointMake(tp_label.center.x - (1-scale) * CGRectGetWidth(tp_label.bounds) / 2.0, -CGRectGetHeight(tp_label.bounds) * scale / 2.0 );
    [UIView animateWithDuration:.2 animations:^{
        tp_label.center = center;
        tp_label.transform = CGAffineTransformMakeScale(scale, scale);
    }];
}

#pragma mark - UIControlEventEditingDidEnd
- (void)tp_endEditing {
    if (!self.placeholder.length || self.text.length > 0) {
        return;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        UILabel *tp_label = self.topPlaceholerLabel;
        UILabel *ori_label = [self valueForKeyPath:@"_placeholderLabel"];
        
        tp_label.transform = CGAffineTransformIdentity;
        tp_label.center = CGPointMake(CGRectGetMinX(ori_label.frame) + CGRectGetWidth(tp_label.bounds) / 2.0, ori_label.center.y);
    } completion:^(BOOL finished) {
        UILabel *tp_label = self.topPlaceholerLabel;
        UILabel *ori_label = [self valueForKeyPath:@"_placeholderLabel"];
        
        tp_label.hidden = YES;
        ori_label.hidden = NO;
    }];
}

#pragma mark - Private
- (void)topPlaceholerLabelStartMoveToTop {
    UILabel *tp_label = self.topPlaceholerLabel;
    UILabel *ori_label = [self valueForKeyPath:@"_placeholderLabel"];
    
    tp_label.font = ori_label.font;
    [tp_label sizeToFit];
    tp_label.center = CGPointMake(CGRectGetMinX(ori_label.frame) + CGRectGetWidth(tp_label.bounds) / 2.0, ori_label.center.y);
    
    tp_label.hidden = NO;
    ori_label.hidden = YES;
}

#pragma mark - Setter & Getter
- (UILabel *)topPlaceholerLabel {
    UILabel *label = objc_getAssociatedObject(self, _cmd);
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.userInteractionEnabled = NO;
        label.text = self.placeholder;
        label.textColor = [self valueForKeyPath:@"_placeholderLabel.textColor"];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        objc_setAssociatedObject(self, _cmd, label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return label;
}

- (void)setTopPlaceholerLabel:(UILabel *)topPlaceholerLabel {
    if (topPlaceholerLabel) {
        if (self.topPlaceholerLabel) {
            [self.topPlaceholerLabel removeFromSuperview];
            
            [self addSubview:topPlaceholerLabel];
            [self bringSubviewToFront:topPlaceholerLabel];
            
            objc_setAssociatedObject(self, @selector(topPlaceholerLabel), topPlaceholerLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)setTopPlaceholerFont:(UIFont *)topPlaceholerFont {
    objc_setAssociatedObject(self, @selector(topPlaceholerLabel), topPlaceholerFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)topPlaceholerFont {
    UIFont *topFont = objc_getAssociatedObject(self, _cmd);
    if (!topFont) {
        topFont = [UIFont systemFontOfSize:12];
        objc_setAssociatedObject(self, _cmd, topFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return topFont;
}

@end
