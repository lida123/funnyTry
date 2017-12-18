//
//  FTOneLoadingAnimationVC.m
//  funnyTry
//
//  Created by SGQ on 2017/12/18.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTOneLoadingAnimationVC.h"
#import "FTOneLoadingAnimationView.h"

@interface FTOneLoadingAnimationVC ()

@end

@implementation FTOneLoadingAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"loading animaton";
    
    FTOneLoadingAnimationView *loadingView = [[FTOneLoadingAnimationView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    loadingView.center = self.view.center;
    loadingView.tag = 199;
    [self.view addSubview:loadingView];
    [loadingView startSuccessAnimation];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    FTOneLoadingAnimationView *loadingView = [self.view viewWithTag:199];
    [loadingView startSuccessAnimation];
}

@end
