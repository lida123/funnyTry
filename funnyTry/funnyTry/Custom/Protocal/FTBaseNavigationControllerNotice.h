//
//  FTBaseNavigationControllerNotice.h
//  funnyTry
//
//  Created by SGQ on 2018/1/5.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FTBaseNavigationControllerNotice <NSObject>

- (void)ft_navigationControllerWillShowMe;
- (void)ft_navigationControllerDidShowMe;

- (void)ft_navigationControllerWillHideMe;
- (void)ft_navigationControllerDidHideMe;

@end
