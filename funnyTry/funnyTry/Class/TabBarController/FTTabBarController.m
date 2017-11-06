//
//  FTTabBarController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/1.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTTabBarController.h"
#import "FTWaterfallViewController.h"

@interface FTTabBarController ()

@end

@implementation FTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:@"waterfall" image:nil tag:0];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"waterfall" image:nil tag:0];
    
    FTWaterfallViewController *waterfall0 = [[FTWaterfallViewController alloc] init];
    waterfall0.tabBarItem = item0;
    
    FTWaterfallViewController *waterfall1 = [[FTWaterfallViewController alloc] init];
    waterfall1.tabBarItem = item1;
    [self setViewControllers:@[waterfall0,waterfall1] animated:YES];
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
