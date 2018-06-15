//
//  FTPlayroundTwoVC.m
//  funnyTry
//
//  Created by SGQ on 2018/4/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTPlayroundTwoVC.h"

@interface FTPlayroundTwoVC ()

@end

@implementation FTPlayroundTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     NSLog(@"two %s",__func__);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     NSLog(@"two %s",__func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     NSLog(@"two %s",__func__);
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"two %s",__func__);
}
@end
