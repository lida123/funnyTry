//
//  FTBaseCell.h
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//  基类cell.子类若继承,model使用item命名且继承FTBaseItem

#import <UIKit/UIKit.h>

@interface FTBaseCell : UITableViewCell

@end

@interface FTBaseItem : NSObject

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, strong) NSIndexPath *indexPath;
/* 分割线颜色 default:RGB(232,232,234) */
@property (nonatomic, strong) UIColor *separatorColor;
/* 分割线左侧间距,延伸至最右侧 -1 表示隐藏分割线 */
@property (nonatomic, assign) CGFloat separatorLeftMargin;
/* 可以设置左右两侧的间距 separatorInset有值时优先使用separatorInset*/
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@end
