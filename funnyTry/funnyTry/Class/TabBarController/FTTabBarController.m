//
//  FTTabBarController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/1.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTTabBarController.h"
#import "FTPlaygroundVC.h"
#import "FTWaterfallViewController.h"
#import "FTUIListViewController.h"
#import "FTBaseNavigationController.h"

@interface FTTabBarController ()

@end

@implementation FTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpsetViewControllers];
}

- (void)setUpsetViewControllers
{
    UITabBarItem *item0 = [[UITabBarItem alloc] init];
    item0.title = @"playground";
    item0.image = [[UIImage imageNamed:@"tabbar_discover_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [[UIImage imageNamed:@"tabbar_discover_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item0 setTitleTextAttributes:@{NSForegroundColorAttributeName:FT_RGBCOLOR(252, 86, 52)} forState:UIControlStateSelected];
    
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.title = @"waterfall";
    item1.image = [[UIImage imageNamed:@"tabbar_discover_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"tabbar_discover_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:FT_RGBCOLOR(252, 86, 52)} forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.title = @"funnny";
    item2.image = [[UIImage imageNamed:@"tabbar_discover_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"tabbar_discover_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:FT_RGBCOLOR(252, 86, 52)} forState:UIControlStateSelected];
    
    FTPlaygroundVC *playground = [[FTPlaygroundVC alloc] init];
    FTBaseNavigationController *navi0 = [[FTBaseNavigationController alloc] initWithRootViewController:playground];
    navi0.tabBarItem = item0;
    
    FTWaterfallViewController *waterfall = [[FTWaterfallViewController alloc] init];
    FTBaseNavigationController *navi1 = [[FTBaseNavigationController alloc] initWithRootViewController:waterfall];
    navi1.tabBarItem = item1;
    
    FTUIListViewController *uiListVC = [[FTUIListViewController alloc] init];
    FTBaseNavigationController *navi2 = [[FTBaseNavigationController alloc] initWithRootViewController:uiListVC];
    navi2.tabBarItem = item2;
    [self setViewControllers:@[navi0,navi1,navi2] animated:YES];
}

@end
