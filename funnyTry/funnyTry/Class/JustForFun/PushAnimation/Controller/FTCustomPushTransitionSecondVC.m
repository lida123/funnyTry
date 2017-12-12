//
//  FTCustomPushTransitionSecondVC.m
//  funnyTry
//
//  Created by SGQ on 2017/12/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomPushTransitionSecondVC.h"
#import "FTCustomTransitioning.h"

@interface FTCustomPushTransitionSecondVC ()
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, strong) FTCustomInteractiveTransitioning *interactiveTranstioning;
@end

@implementation FTCustomPushTransitionSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"second";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic1.jpg"]];
    [self.view addSubview:imageView];
    imageView.frame = self.view.frame;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 30);
    button.backgroundColor = [UIColor greenColor];
    button.center = self.view.center;
    [button setTitle:@"点我或向右滑动pop" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    
    self.interactiveTranstioning = [FTCustomInteractiveTransitioning interactiveTransitioningWithType:FTCustomInteractiveTransitioningTypePop];
    [self.interactiveTranstioning addPanGestureForViewController:self];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    self.operation = operation;
    if (operation == UINavigationControllerOperationPush) {
        return [FTCustomTransitioning transitioningWithType:FTCustomTransitioningPageCurl actionType:@"push"];
    }else if(operation == UINavigationControllerOperationPop){
        return [FTCustomTransitioning transitioningWithType:FTCustomTransitioningPageUnCurl actionType:@"pop"];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController  {
    if (self.operation == UINavigationControllerOperationPush) {
        return self.lastInteractiveTranstioning;
    }else if(self.operation == UINavigationControllerOperationPop){
        return self.interactiveTranstioning;
    }
    return nil;
}

@end
