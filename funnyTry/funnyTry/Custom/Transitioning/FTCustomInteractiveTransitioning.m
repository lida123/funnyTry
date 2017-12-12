//
//  FTCustomInteractiveTransitioning.m
//  funnyTry
//
//  Created by SGQ on 2017/12/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTCustomInteractiveTransitioning.h"

@interface FTCustomInteractiveTransitioning()
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) FTCustomInteractiveTransitioningType type;
@end

@implementation FTCustomInteractiveTransitioning

- (instancetype)initWithType:(FTCustomInteractiveTransitioningType)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

+ (instancetype)interactiveTransitioningWithType:(FTCustomInteractiveTransitioningType)type {
    return [[self alloc] initWithType:type];
}

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:panGesture];
}

- (void)handleGesture:(UIPanGestureRecognizer*)panGesture {
    CGPoint currentPoint = [panGesture translationInView:panGesture.view];
    NSLog(@"%@",NSStringFromCGPoint(currentPoint));
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self startGesture];
    }else if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        switch (self.type) {
            case FTCustomInteractiveTransitioningTypePush:
                
                break;
                
            case FTCustomInteractiveTransitioningTypePop:
                [_vc.navigationController popViewControllerAnimated:YES]
                ;
                break;
                
            case FTCustomInteractiveTransitioningTypePresent:
                self.PresentBlock();
                break;
                
            case FTCustomInteractiveTransitioningTypeDismsiss:
                [_vc dismissViewControllerAnimated:YES completion:nil];
                break;
        }
        
        
    }else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self finishInteractiveTransition];
    }
}

- (void)startGesture{
    switch (self.type) {
        case FTCustomInteractiveTransitioningTypePush:
            self.PushBlock();
            break;
            
        case FTCustomInteractiveTransitioningTypePop:
            [_vc.navigationController popViewControllerAnimated:YES]
            ;
            break;
            
        case FTCustomInteractiveTransitioningTypePresent:
            self.PresentBlock();
            break;
            
        case FTCustomInteractiveTransitioningTypeDismsiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

@end
