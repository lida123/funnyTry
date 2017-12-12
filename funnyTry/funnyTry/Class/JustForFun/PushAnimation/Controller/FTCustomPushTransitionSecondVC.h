//
//  FTCustomPushTransitionSecondVC.h
//  funnyTry
//
//  Created by SGQ on 2017/12/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTCustomInteractiveTransitioning.h"

@interface FTCustomPushTransitionSecondVC : FTBaseViewController <UINavigationControllerDelegate>
@property (nonatomic, strong) FTCustomInteractiveTransitioning *lastInteractiveTranstioning;
@end
