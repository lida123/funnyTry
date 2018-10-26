//
//  FTRetainCyleView.h
//  funnyTry
//
//  Created by SGQ on 2018/10/25.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTRetainCyleView : UIView
@property (nonatomic, copy) void (^myBlock)(void);
@end
