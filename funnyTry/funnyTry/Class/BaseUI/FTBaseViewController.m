//
//  FTBaseViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/3.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTBaseViewController ()
@property (nonatomic, assign) NSUInteger countOfInVieWillAppear;
@property (nonatomic, assign) NSUInteger countOfInViewDidAppear;
@end

@implementation FTBaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _countOfInVieWillAppear = 0;
        _countOfInViewDidAppear = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AppDefaultBackgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.countOfInVieWillAppear ++;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.countOfInViewDidAppear ++;
    
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
