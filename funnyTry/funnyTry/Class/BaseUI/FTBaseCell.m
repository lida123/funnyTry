//
//  FTBaseCell.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseCell.h"

@interface FTBaseCell()
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation FTBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (UIView *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = FT_RGBCOLOR(232,232,234);
        _separatorLine.hidden = YES;
        [self.contentView addSubview:_separatorLine];
    }
    return _separatorLine;
}

- (void)setObject:(id)obj {
    if (obj && [obj isKindOfClass:[FTBaseItem class]]) {
        FTBaseItem *item = (FTBaseItem *)obj;
        self.accessoryType = item.accessoryType;
        self.selectionStyle = item.selectionStyle;
        if (item.separatorColor) {
            self.separatorLine.backgroundColor = item.separatorColor;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /* 尝试读取子类item属性 */
    if ([self respondsToSelector:@selector(item)]) {
        FTBaseItem *item = [self performSelector:@selector(item)];
        if (item && [item isKindOfClass:[FTBaseItem class]]) {
            if (item.separatorLeftMargin >= 0 || !UIEdgeInsetsEqualToEdgeInsets(item.separatorInset, UIEdgeInsetsZero)) {
                [self.contentView bringSubviewToFront:self.separatorLine];
                self.separatorLine.hidden = NO;
                
                /* 优先使用separatorInset */
                if (!UIEdgeInsetsEqualToEdgeInsets(item.separatorInset, UIEdgeInsetsZero)) {
                    CGFloat w = CGRectGetWidth(self.contentView.bounds) - item.separatorInset.left - item.separatorInset.right;
                    CGFloat h = FT_SINGLE_LINE_HIEGHT;
#if TARGET_OS_SIMULATOR
                    h = 1;
#endif
                    CGFloat y = CGRectGetHeight(self.contentView.bounds) - h;
                    CGFloat x = item.separatorInset.left;
                    self.separatorLine.frame = CGRectMake(x, y, w, h);
                }else {
                    CGFloat w = CGRectGetWidth(self.contentView.bounds) - item.separatorLeftMargin;
                    CGFloat h = FT_SINGLE_LINE_HIEGHT;
#if TARGET_OS_SIMULATOR
                    h = 1;
#endif
                    CGFloat y = CGRectGetHeight(self.contentView.bounds) - h;
                    CGFloat x = item.separatorLeftMargin;
                    self.separatorLine.frame = CGRectMake(x, y, w, h);
                }
            }
        }else {
            _separatorLine.hidden = YES;
        }
    }
}

@end


@implementation FTBaseItem



@end
