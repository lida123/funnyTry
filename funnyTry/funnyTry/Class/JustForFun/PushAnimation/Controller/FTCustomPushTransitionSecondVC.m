//
//  FTCustomPushTransitionSecondVC.m
//  funnyTry
//
//  Created by SGQ on 2017/12/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomPushTransitionSecondVC.h"
#import "FTCustomTransitioning.h"
#import "Masonry.h"

@interface FTCustomPushTransitionSecondVC ()
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, strong) FTCustomInteractiveTransitioning *interactiveTransitionPop;
@end

@implementation FTCustomPushTransitionSecondVC

- (void)dealloc{
    FTDPRINT(@"销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"second";
    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic1.jpg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点我或向右滑动pop" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(74);
    }];
    
    //初始化手势过渡的代理
    _interactiveTransitionPop = [FTCustomInteractiveTransitioning interactiveTransitioningWithType:FTCustomInteractiveTransitioningTypePop];
    //给当前控制器的视图添加手势
    [_interactiveTransitionPop addPanGestureForViewController:self];
}

- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    _operation = operation;
    //分pop和push两种情况分别返回动画过渡代理相应不同的动画操作
    return [FTCustomTransitioning transitioningWithType:FTCustomTransitioningCube actionType:operation == UINavigationControllerOperationPush ? @"push" : @"pop"];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    if (_operation == UINavigationControllerOperationPush) {
        return _lastInteractiveTranstioning.interation ? _lastInteractiveTranstioning:nil;
    }else{
        return _interactiveTransitionPop.interation ? _interactiveTransitionPop:nil;
    }
}
@end
