//
//  FTUIListCell.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTUIListCell.h"
#import "FBShimmeringView.h"

@interface FTUIListCell()
@property (nonatomic, strong) FBShimmeringView *shimmeringView;
@property (nonatomic, strong) UILabel *shimmeringLabel;
@end

@implementation FTUIListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_shimmeringView];
        
        _shimmeringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shimmeringLabel.textColor = [UIColor purpleColor];
        _shimmeringLabel.textAlignment = NSTextAlignmentLeft;
        _shimmeringLabel.font = [UIFont systemFontOfSize:18];
        [_shimmeringView addSubview:_shimmeringLabel];
    }
    return self;
}

- (void)setItem:(FTUIListCellIem *)item {
    _item = item;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shimmeringView.frame = CGRectMake(0,0, CGRectGetWidth(self.contentView.bounds),CGRectGetHeight(self.contentView.bounds));
    self.shimmeringLabel.frame = self.shimmeringView.bounds;
}
@end
