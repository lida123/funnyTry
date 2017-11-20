//
//  FTBaseViewController.h
//  funnyTry
//
//  Created by SGQ on 2017/11/3.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTBaseViewController : UIViewController
/**
 * record the count of call back 'viewWillAppear'
 */
@property (nonatomic, readonly) NSUInteger countOfInVieWillAppear;

/**
 * record the count of call back 'viewDidAppear'
 */
@property (nonatomic, readonly) NSUInteger countOfInViewDidAppear;

@end
