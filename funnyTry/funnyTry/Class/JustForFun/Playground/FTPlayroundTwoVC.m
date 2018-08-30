//
//  FTPlayroundTwoVC.m
//  funnyTry
//
//  Created by SGQ on 2018/4/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

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
    [self.topTextField endEditing:YES];
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
