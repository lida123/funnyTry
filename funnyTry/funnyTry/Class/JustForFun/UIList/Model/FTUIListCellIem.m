//
//  FTUIListCellIem.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTUIListCellIem.h"

@implementation FTUIListCellIem

+ (instancetype)itemWithText:(NSString *)text {
    FTUIListCellIem *item = [[self alloc] init];
    item.text = text;
    return item;
}
@end
