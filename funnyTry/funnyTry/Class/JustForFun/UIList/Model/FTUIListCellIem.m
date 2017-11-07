//
//  FTUIListCellIem.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTUIListCellIem.h"

@implementation FTUIListCellIem

+ (instancetype)itemWithClassString:(NSString *)classString shimmering:(BOOL)shimmering {
    FTUIListCellIem *item = [[self alloc] init];
    item.classString = classString;
    item.shimmering = shimmering;
    return item;
}

- (NSString *)classDescription {
    if ([self.classString isEqualToString:@"FTScanViewController"]) {
        return @"scan or create two-dimension code";
    }
    return nil;
}
@end
