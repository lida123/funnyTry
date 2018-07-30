//
//  UIViewController+Association.h
//  funnyTry
//
//  Created by SGQ on 2018/7/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Association)

@property (assign, nonatomic) NSString *associatedObject_assign;
@property (strong, nonatomic) NSString *associatedObject_retain;
@property (copy,   nonatomic) NSString *associatedObject_copy;

@end
