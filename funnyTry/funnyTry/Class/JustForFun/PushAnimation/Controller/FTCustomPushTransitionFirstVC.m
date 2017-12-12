//
//  FTCustomPushTransitionFirstVC.m
//  funnyTry
//
//  Created by SGQ on 2017/12/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomPushTransitionFirstVC.h"
#import "FTCustomPushTransitionSecondVC.h"


@interface FTCustomPushTransitionFirstVC ()
@property (nonatomic, strong) FTCustomInteractiveTransitioning *interactiveTranstioning;
@end

@implementation FTCustomPushTransitionFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"first";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic2.jpeg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 30);
    button.center = self.view.center;
    [button setTitle:@"点我或向左滑动push" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    ADDSelectorForButton(button, self, @selector(push));
    [self.view addSubview:button];
    
    self.interactiveTranstioning = [FTCustomInteractiveTransitioning interactiveTransitioningWithType:FTCustomInteractiveTransitioningTypePush];
    WS(weakSelf)
    self.interactiveTranstioning.PushBlock = ^{
        [weakSelf push];
    };
    [self.interactiveTranstioning addPanGestureForViewController:self];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)backToRoot
{
    self.navigationController.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)push {
    FTCustomPushTransitionSecondVC *secondVC = [[FTCustomPushTransitionSecondVC alloc] init];
    self.navigationController.delegate = secondVC;
    secondVC.lastInteractiveTranstioning = self.interactiveTranstioning;
    [self.navigationController pushViewController:secondVC animated:YES];
}

@end
