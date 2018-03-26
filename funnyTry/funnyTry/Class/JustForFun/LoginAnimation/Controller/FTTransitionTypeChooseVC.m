//
//  FTTransitionTypeChooseVC.m
//  funnyTry
//
//  Created by SGQ on 2017/12/4.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTTransitionTypeChooseVC.h"

@interface FTTransitionTypeChooseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *types;
@end

@implementation FTTransitionTypeChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.types = @[@"fade",@"push",@"moveIn",@"reveal",@"oglFlip",@"cube",@"suckEffect",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"typeChooseCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *type = self.types[indexPath.row];
    cell.textLabel.text = type;
    cell.textLabel.textColor = [UIColor purpleColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *type = self.types[indexPath.row];
    if (self.CompletionBlock) {
        self.CompletionBlock(type);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.types.count;
}

@end
