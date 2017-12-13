//
//  FTCircleLoadingViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/16.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCircleLoadingViewController.h"
#import "FTCircleLoadingView.h"
#import "UIButton+CircleLoading.h"

@interface FTCircleLoadingViewController ()
@property (nonatomic, strong) FTCircleLoadingView *loadingView;
@end

@implementation FTCircleLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"loading" style:UIBarButtonItemStylePlain target:self action:@selector(startLoading:)];
    
    _loadingView = [[FTCircleLoadingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _loadingView.center = self.view.center;
    [self.view addSubview:_loadingView];
    _loadingView.endBlock = ^() {

    };
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 100, 200, 50);
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.tag = 199;
    [self.view addSubview:btn];
    [btn cl_setLayerColor:[UIColor whiteColor]];
    
    [btn addTarget:self action:@selector(btnStartLoading) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnStartLoading {
    UIButton *btn = [self.view viewWithTag:199];
    [btn setTitle:@"支付中" forState:UIControlStateNormal];
    [btn cl_startLoading];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIButton *btn = [self.view viewWithTag:199];
    [btn setTitle:@"支付成功" forState:UIControlStateNormal];
    [btn cl_endLoadingSucceedWithEndBlock:^{

    }];
}


#pragma mark - rightItemAction
- (void)startLoading:(UIBarButtonItem *)item {
    UIButton *btn = [self.view viewWithTag:199];
    if ([item.title isEqualToString:@"loading"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"success" style:UIBarButtonItemStylePlain target:self action:@selector(startLoading:)];
        [btn setTitle:@"支付中" forState:UIControlStateNormal];
        [_loadingView startLoading];
        
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"loading" style:UIBarButtonItemStylePlain target:self action:@selector(startLoading:)];
        [_loadingView endLoadingSucceed];
    }
}

@end
