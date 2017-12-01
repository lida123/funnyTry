//
//  UIViewController+FTBaseNavigationControllerNotice.h
//  funnyTry
//
//  Created by SGQ on 2017/11/30.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FTBaseNavigationControllerNotice)
- (void)ft_navigationControllerWillShowMe;
- (void)ft_navigationControllerDidShowMe;

- (void)ft_navigationControllerWillHideMe;
- (void)ft_navigationControllerDidHideMe;
@end
