//
//  FTTransitionTypeChooseVC.h
//  funnyTry
//
//  Created by SGQ on 2017/12/4.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTTransitionTypeChooseVC : FTBaseViewController
@property (nonatomic, copy) void (^CompletionBlock)(NSString* type);
@end
