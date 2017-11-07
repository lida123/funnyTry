//
//  FTUIListCellIem.h
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseCell.h"

@interface FTUIListCellIem : FTBaseItem
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign ,getter=isShimmering) BOOL shimmering;

+ (instancetype)itemWithText:(NSString *)text;
@end
