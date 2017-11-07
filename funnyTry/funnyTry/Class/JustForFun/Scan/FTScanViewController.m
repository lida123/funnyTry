//
//  FTScanViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTScanViewController.h"

@interface FTScanViewController ()

@end

@implementation FTScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
}

#pragma mark -rightItemAction
- (void)rightItemClick:(UIBarButtonItem *)item {
    
}

@end
