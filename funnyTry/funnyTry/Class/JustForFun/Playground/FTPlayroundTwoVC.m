//
//  FTPlayroundTwoVC.m
//  funnyTry
//
//  Created by SGQ on 2018/4/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

void addLeftBottomRightShadowToView(UIView *view,CGFloat shadowOpacity,CGFloat leftOffSet, CGFloat rightOffSet,CGFloat bottomOffset,CGSize viewSize)
{
    //////// shadow /////////
    CALayer *shadowLayer = view.layer;
    
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(0, 0);
    shadowLayer.shadowOpacity = shadowOpacity;
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = viewSize.width;
    CGFloat h = viewSize.height;
    
    [path moveToPoint:CGPointMake(x - leftOffSet, y + bottomOffset)]; //左上
    [path addLineToPoint:CGPointMake(x - leftOffSet, y + h + bottomOffset)];//左下
    [path addLineToPoint:CGPointMake(x + w + rightOffSet, y + h + bottomOffset)];//右下
    [path addLineToPoint:CGPointMake(x + w + rightOffSet, y + bottomOffset)];//右上
    [path addLineToPoint:CGPointMake(x - leftOffSet, y + bottomOffset)]; //左上
    shadowLayer.shadowPath = path.CGPath;
}


#import "FTPlayroundTwoVC.h"
#import "UIViewController+Association.h"
#import "UITextField+TopPlaceholder.h"

__weak NSString *string_weak_assign = nil;
__weak NSString *string_weak_retain = nil;
__weak NSString *string_weak_copy   = nil;

@interface FTPlayroundTwoVC ()
@property (strong, nonatomic) IBOutlet UITextField *topTextField;

@end

@implementation FTPlayroundTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    self.associatedObject_assign = [NSString stringWithFormat:@"leichunfeng1"];
    self.associatedObject_retain = [NSString stringWithFormat:@"leichunfeng2"];
    self.associatedObject_copy   = [NSString stringWithFormat:@"leichunfeng3"];
    
    string_weak_assign = self.associatedObject_assign;
    string_weak_retain = self.associatedObject_retain;
    string_weak_copy   = self.associatedObject_copy;
    
    [self.topTextField enableTopPlaceholder];
    
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 200, 50)];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.cornerRadius = 10;
    redView.tag = 999;
    
    [self.view addSubview:redView];
    
    addLeftBottomRightShadowToView(redView, 0.5, 5, 5, 5, redView.frame.size);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    NSLog(@"%s--%@",__func__, parent);
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    NSLog(@"%s--%@",__func__, parent);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self.topTextField endEditing:YES];
    
    CGFloat totalTime = 1.05;
    NSArray *keyTimes = @[@0, @(0.2/totalTime), @(0.45/totalTime), @(0.75/totalTime), @(1)];
    
    UIView *redView = [self.view viewWithTag:999];
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animation];
    keyFrame.keyPath = @"transform.translation.y";
    keyFrame.values = @[@(0), @(-30), @(0), @(-10), @(0)];
    keyFrame.keyTimes = keyTimes;
    keyFrame.removedOnCompletion = NO;
    keyFrame.duration = totalTime;
    
    CAKeyframeAnimation *keyFrame1 = [CAKeyframeAnimation animation];
    keyFrame1.keyPath = @"transform.scale";
    keyFrame1.values = @[@(1.0), @(1.2), @(1.0), @(1.1), @(1.0)];
    keyFrame1.keyTimes = keyTimes;
    keyFrame1.duration = totalTime;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = totalTime;
    group.animations = @[keyFrame, keyFrame1];
    [redView.layer addAnimation:group forKey:nil];

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
