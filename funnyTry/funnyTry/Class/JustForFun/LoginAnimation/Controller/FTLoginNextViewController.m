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
@property (nonatomic, copy) NSString *type;
@end

@implementation FTLoginNextViewController

- (instancetype)initWithAnimationType:(NSString *)type {
    if (self = [self initWithNibName:nil bundle:nil]) {
        _type = type;
    }
    return self;
}

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
}

- (void)tap:(UITapGestureRecognizer*)tap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [FTCustomTransitioning transitioningWithType:[self transitioningType:YES] actionType:@"present"];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [FTCustomTransitioning transitioningWithType:[self transitioningType:NO] actionType:@"dismiss"];
}

- (FTCustomTransitioningType)transitioningType:(BOOL)present{
    if ([self.type isEqualToString:@"circelScale"]) {
        if (present) {
            return FTCustomTransitioningCircleMagnify;
        }else {
            return FTCustomTransitioningCircleShrink;
        }
    }else if ([self.type isEqualToString:@"fade"]) {
        return FTCustomTransitioningFade;
    }else if ([self.type isEqualToString:@"push"]) {
        return FTCustomTransitioningPush;
    }else if ([self.type isEqualToString:@"fade"]) {
        return FTCustomTransitioningFade;
    }else if ([self.type isEqualToString:@"moveIn"]) {
        return FTCustomTransitioningMoveIn;
    }else if ([self.type isEqualToString:@"reveal"]) {
        return FTCustomTransitioningReveal;
    }else if ([self.type isEqualToString:@"oglFlip"]) {
        return FTCustomTransitioningOgFlip;
    }else if ([self.type isEqualToString:@"cube"]) {
        return FTCustomTransitioningCube;
    }else if ([self.type isEqualToString:@"suckEffect"]) {
        return FTCustomTransitioningSuckEffect;
    }else if ([self.type isEqualToString:@"rippleEffect"]) {
        return FTCustomTransitioningRippleEffect;
    }else if ([self.type isEqualToString:@"pageCurl"]) {
        return FTCustomTransitioningPageCurl;
    }else if ([self.type isEqualToString:@"pageUnCurl"]) {
        return FTCustomTransitioningPageUnCurl;
    }else if ([self.type isEqualToString:@"cameraIrisHollowOpen"]) {
        if (present) {
            return FTCustomTransitioningCameraIrisHollowOpen;
        }else {
            return FTCustomTransitioningCameraIrisHollowClose;
        }
    }else if ([self.type isEqualToString:@"cameraIrisHollowClose"]) {
        if (present) {
            return FTCustomTransitioningCameraIrisHollowOpen;
        }else {
            return FTCustomTransitioningCameraIrisHollowClose;
        }
    }
    
    return FTCustomTransitioningCircleMagnify;
}

@end
