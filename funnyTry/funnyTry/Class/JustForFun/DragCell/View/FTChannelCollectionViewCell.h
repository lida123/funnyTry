//
//  FTChannelCollectionViewCell.h
//  funnyTry
//
//  Created by SGQ on 2017/12/12.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTChannelCollectionViewCell : UICollectionViewCell

//标题
@property (nonatomic, copy) NSString *title;

//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

//是否被固定
@property (nonatomic, assign) BOOL isFixed;

@end
