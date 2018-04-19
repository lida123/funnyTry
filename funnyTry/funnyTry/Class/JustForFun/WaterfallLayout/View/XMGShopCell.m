//
//  AppDelegate.h
//  funnyTry
//
//  Created by SGQ on 2017/10/31.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "XMGShopCell.h"
#import "XMGShop.h"
#import "UIImageView+WebCache.h"

@interface XMGShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation XMGShopCell

- (void)setShop:(XMGShop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
