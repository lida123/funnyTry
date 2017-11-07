//
//  FTScanViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTScanViewController.h"
#import "LJSaomiaoViewController.h"

@interface FTScanViewController ()
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation FTScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
}

#pragma mark -rightItemAction
- (void)rightItemClick:(UIBarButtonItem *)item {
    LJSaomiaoViewController *scanVC = [[LJSaomiaoViewController alloc] init];
    WS(weakSelf)
    [scanVC setResultBlock:^(NSString *result) {
        [weakSelf showResult:result];
    }];
    [self.navigationController presentViewController:scanVC animated:YES completion:nil];
}

- (void)showResult:(NSString *)result {
    self.resultLabel.text = result;
    [self.resultLabel sizeToFit];
    self.resultLabel.center = self.view.center;
    [self.view addSubview:self.resultLabel];
}

#pragma mark - lazy initialize
-(UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
        _resultLabel.textColor = [UIColor purpleColor];
    }
    return _resultLabel;
}
@end
