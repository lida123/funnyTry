//
//  FTTabBarController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/1.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTTabBarController.h"
#import "FTWaterfallViewController.h"
#import "FTUIListViewController.h"
#import "FTBaseNavigationController.h"

@interface FTTabBarController ()

@end

@implementation FTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *item0 = [[UITabBarItem alloc] init];
    item0.title = @"waterfall";
    item0.image = [[UIImage imageNamed:@"tabbar_discover_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item0.selectedImage = [[UIImage imageNamed:@"tabbar_discover_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item0 setTitleTextAttributes:@{NSForegroundColorAttributeName:FT_RGBCOLOR(252, 86, 52)} forState:UIControlStateSelected];
    
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.title = @"funnny";
    item1.image = [[UIImage imageNamed:@"tabbar_discover_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.selectedImage = [[UIImage imageNamed:@"tabbar_discover_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:FT_RGBCOLOR(252, 86, 52)} forState:UIControlStateSelected];

    
    FTWaterfallViewController *waterfall = [[FTWaterfallViewController alloc] init];
    FTBaseNavigationController *navi0 = [[FTBaseNavigationController alloc] initWithRootViewController:waterfall];
    navi0.tabBarItem = item0;
    
    FTUIListViewController *uiListVC = [[FTUIListViewController alloc] init];
    FTBaseNavigationController *navi1 = [[FTBaseNavigationController alloc] initWithRootViewController:uiListVC];
    navi1.tabBarItem = item1;
    [self setViewControllers:@[navi0,navi1] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
