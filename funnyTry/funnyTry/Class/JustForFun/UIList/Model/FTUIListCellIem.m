//
//  FTUIListCellIem.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTUIListCellIem.h"

@implementation FTUIListCellIem

- (instancetype)init {
    if (self = [super init]) {
        self.cellHeight = 44.0f;
    }
    return self;
}

+ (instancetype)itemWithClassString:(NSString *)classString shimmering:(BOOL)shimmering {
    FTUIListCellIem *item = [[self alloc] init];
    item.classString = classString;
    item.shimmering = shimmering;
    return item;
}

- (void)setCellWidth:(CGFloat)cellWidth {
    [super setCellWidth:cellWidth];
    CGFloat leftMargin = 14;
    CGFloat rightMargin = 5;
    CGRect labelFrame = [self.classDescription boundingRectWithSize:CGSizeMake(cellWidth - leftMargin - rightMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil];
    self.cellHeight = MAX(CGRectGetHeight(labelFrame) + 10, 44);
    labelFrame.origin.y = (self.cellHeight - CGRectGetHeight(labelFrame)) / 2.0;
    labelFrame.origin.x = leftMargin;
    self.shimmeringViewFrame = labelFrame;
}

- (NSString *)classDescription {
    if ([self.classString isEqualToString:@"FTScanViewController"]) {
        return @"scan or create two-dimension code";
    }else if([self.classString isEqualToString:@"FTFlowMountainViewController"]) {
        return @"flow mountain";
    }else if([self.classString isEqualToString:@"FTCircleLoadingViewController"]) {
        return @"circle loading animation";
    }else if ([self.classString isEqualToString:@"FTLoginViewController"]) {
        return @"custom login animation & custom present_pop transitioning animation";
    }else if ([self.classString isEqualToString:@"FTCustomPushTransitionFirstVC"]) {
        return @"custom push pop interactive transtioning";
    }else if ([self.classString isEqualToString:@"FTDragCellViewController"]) {
        return @"tencent news's chanel manager view";
    }else if ([self.classString isEqualToString:@"XWPageCoverController"]) {
        return @"XWPageCoverController";
    }
    else {
        
    }
    return nil;
}


@end
