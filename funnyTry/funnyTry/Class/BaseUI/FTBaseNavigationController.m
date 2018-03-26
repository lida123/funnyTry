//
//  FTBaseNavigationController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseNavigationController.h"
#import "FTBaseNavigationControllerNotice.h"

@interface FTBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation FTBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 将显示的Controller
    if ([viewController respondsToSelector:@selector(ft_navigationControllerWillShowMe)]) {
        [viewController performSelector:@selector(ft_navigationControllerWillShowMe)];
    }
    
    // 将消失的Controller
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index >= 1) {
         UIViewController *disappearController = [self.viewControllers objectAtIndex:index - 1];
        if ([disappearController respondsToSelector:@selector(ft_navigationControllerWillHideMe)]) {
            [disappearController performSelector:@selector(ft_navigationControllerWillHideMe)];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 将显示的Controller
    if ([viewController respondsToSelector:@selector(ft_navigationControllerDidShowMe)]) {
        [viewController performSelector:@selector(ft_navigationControllerDidShowMe)];
    }
    
    // 将消失的Controller
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index >= 1) {
        UIViewController *disappearController = [self.viewControllers objectAtIndex:index - 1];
        if ([disappearController respondsToSelector:@selector(ft_navigationControllerDidHideMe)]) {
            [disappearController performSelector:@selector(ft_navigationControllerDidHideMe)];
        }
    }
    
    BOOL isRootVC = (viewController == navigationController.viewControllers.firstObject);
    navigationController.interactivePopGestureRecognizer.enabled = !isRootVC;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
