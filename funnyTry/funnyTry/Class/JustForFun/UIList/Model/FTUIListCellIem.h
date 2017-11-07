//
//  FTUIListCellIem.h
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseCell.h"

@interface FTUIListCellIem : FTBaseItem
@property (nonatomic, copy) NSString *classString;
@property (nonatomic, assign ,getter=isShimmering) BOOL shimmering;

+ (instancetype)itemWithClassString:(NSString *)classString shimmering:(BOOL)shimmering;

- (NSString *)classDescription;
@end
