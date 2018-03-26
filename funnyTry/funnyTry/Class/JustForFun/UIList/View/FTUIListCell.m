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
        _shimmeringView.shimmering = NO;
        _shimmeringView.shimmeringOpacity = 0.3;
        [self.contentView addSubview:_shimmeringView];
        
        _shimmeringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shimmeringLabel.backgroundColor = [UIColor clearColor];
        _shimmeringLabel.textColor = [UIColor purpleColor];
        _shimmeringLabel.textAlignment = NSTextAlignmentLeft;
        _shimmeringLabel.numberOfLines = 0;
        _shimmeringLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return self;
}

- (void)setItem:(FTUIListCellIem *)item {
    [self setObject:item];
    _item = item;
    
    self.shimmeringView.shimmering = item.shimmering;
    self.shimmeringLabel.text = item.classDescription;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shimmeringView.frame = self.item.shimmeringViewFrame;
    _shimmeringView.contentView = _shimmeringLabel;
    self.shimmeringLabel.frame = self.shimmeringView.bounds;
}
@end
