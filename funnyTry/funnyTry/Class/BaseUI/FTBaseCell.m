//
//  FTBaseCell.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseCell.h"

@interface FTBaseCell()
@property (nonatomic, strong) CALayer *separatorLine;
@end

@implementation FTBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _separatorLine = [[CALayer alloc] init];
        _separatorLine.backgroundColor = FT_RGBCOLOR(232,232,234).CGColor;
        _separatorLine.hidden = YES;
        [self.contentView.layer addSublayer:_separatorLine];
    }
    return self;
}

- (void)setItem:(FTBaseItem *)item {
    if (item && [item isKindOfClass:[FTBaseItem class]]) {
        self.accessoryType = item.accessoryType;
        self.selectionStyle = item.selectionStyle;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    /* 尝试读取子类item属性 */
    if ([self respondsToSelector:@selector(item)]) {
        FTBaseItem *item = [self performSelector:@selector(item)];
        if (item && [item isKindOfClass:[FTBaseItem class]]) {
            if (item.separatorLeftMargin == -1) {
                self.separatorLine.hidden = YES;
            }else {
                /* 优先使用separatorInset */
                if (!UIEdgeInsetsEqualToEdgeInsets(self.separatorInset, UIEdgeInsetsZero)) {
                    CGFloat w = CGRectGetWidth(self.contentView.bounds) - item.separatorInset.left - item.separatorInset.right;
                    CGFloat h = FT_SINGLE_LINE_HIEGHT;
                    CGFloat y = CGRectGetHeight(self.contentView.bounds) - h;
                    CGFloat x = item.separatorInset.left;
                    self.separatorLine.frame = CGRectMake(x, y, w, h);
                }else {
                    CGFloat w = CGRectGetWidth(self.contentView.bounds) - item.separatorLeftMargin;
                    CGFloat h = FT_SINGLE_LINE_HIEGHT;
                    CGFloat y = CGRectGetHeight(self.contentView.bounds) - h;
                    CGFloat x = item.separatorLeftMargin;
                    self.separatorLine.frame = CGRectMake(x, y, w, h);
                }
            }
        }
    }
}

@end


@implementation FTBaseItem



@end
