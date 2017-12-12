//
//  FTChannelManager.h
//  funnyTry
//
//  Created by SGQ on 2017/12/12.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ChanelEndBlock)(NSArray *inUseTitles,NSArray *unUseTitles);

@interface FTChannelManager : NSObject

+ (instancetype)sharedManager;

- (void)showChannelViewWithInUseTitles:(NSArray*)inUseTitles unUseTitles:(NSArray*)unUseTitles finish:(ChanelEndBlock)block;

@end
