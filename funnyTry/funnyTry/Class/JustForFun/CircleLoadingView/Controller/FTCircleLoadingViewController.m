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
    [btn setTitle:@"我是title" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    btn.tag = 199;
    [self.view addSubview:btn];
    [btn cl_setLayerColor:[UIColor whiteColor]];

}

static NSInteger a = 0;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIButton *btn = [self.view viewWithTag:199];
    WS(weakSelf)
    if ((a % 2) == 0) {
          [btn cl_startLoading];
    }else {
        [btn cl_endLoadingSucceedWithEndBlock:^{
            [weakSelf end];
        }];
    }
    a++;
    
    
}

- (void)end {
    //FTDPRINT(@"");
}

#pragma mark - rightItemAction
- (void)startLoading:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"loading"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"success" style:UIBarButtonItemStylePlain target:self action:@selector(startLoading:)];
            [_loadingView startLoading];
        
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"loading" style:UIBarButtonItemStylePlain target:self action:@selector(startLoading:)];
        [_loadingView endLoadingSucceed];
    }
}

@end
