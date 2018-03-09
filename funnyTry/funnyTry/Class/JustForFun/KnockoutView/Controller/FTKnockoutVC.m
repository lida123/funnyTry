//
//  FTKnockoutVC.m
//  funnyTry
//
//  Created by SGQ on 2018/3/8.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTKnockoutVC.h"
#import "FTKnockoutView.h"

@interface FTKnockoutVC ()

@end

@implementation FTKnockoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"draw knockoutView";
    
    FTKnockoutView *knockoutView = [[FTKnockoutView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
    [knockoutView setResults:@[@0,@1,@0,@1,@0,@1,@0,@1,@0,@1,@0,@1,@0,@1,@0,@1]];
    [self.view addSubview:knockoutView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
