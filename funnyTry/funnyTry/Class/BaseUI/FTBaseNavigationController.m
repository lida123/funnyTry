//
//  FTBaseNavigationController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseNavigationController.h"
#import "FTBaseNavigationControllerNotice.h"

@interface FTBaseNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

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
    
    [self.navigationBar setBarStyle:UIBarStyleDefault];
}

-(void)initGlobalPan
{
    //取消系统自带手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //获取系统的手势的target数组
    NSMutableArray *_targets = [self.interactivePopGestureRecognizer valueForKeyPath:@"_targets"];
    //获取target
    id target = [[_targets firstObject] valueForKeyPath:@"_target"];
    //获取action
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    //创建一个与系统一样的手势 只把它的类改为UIPanGestureRecognizer
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: target action: action];
    popRecognizer.delegate = self;
    //添加到系统手势作用的view上
    UIView *gestureView = self.interactivePopGestureRecognizer.view;
    [gestureView addGestureRecognizer:popRecognizer];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //当前控制器为根控制器，pop动画正在执行的时候不允许手势
    return self.viewControllers.count != 1 && ![[self valueForKeyPath:@"_isTransitioning"] boolValue];
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

#pragma mark - Getter
@end
