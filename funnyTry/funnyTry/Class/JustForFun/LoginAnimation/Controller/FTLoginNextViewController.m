//
//  FTLoginNextViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/12/4.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTLoginNextViewController.h"
#import "FTCustomTransitioning.h"

@interface FTLoginNextViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation FTLoginNextViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"pic1.jpg"];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
}

- (void)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [FTCustomTransitioning transitioningWithType:FTCustomTransitioningCircleMagnify];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [FTCustomTransitioning transitioningWithType:FTCustomTransitioningCircleShrink];;
}

@end
