//
//  FTUIListViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTUIListViewController.h"
#import "FTUIListCell.h"
#import "FBShimmeringView.h"

@interface FTUIListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation FTUIListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Shimmering" style:UIBarButtonItemStylePlain target:self action:@selector(turnShimmerOn:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    NSMutableArray *items = [NSMutableArray array];
    NSArray *classes = @[@"FTScanViewController",@"FTFlowMountainViewController",@"FTCircleLoadingViewController",@"FTLoginViewController",@"FTCustomPushTransitionFirstVC",@"FTDragCellViewController",@"FTPausePlayAnimationVC",@"FTOneLoadingAnimationVC",@"FTLetterPathViewController"];
    for (NSInteger i = 0; i < classes.count; i++) {
        FTUIListCellIem *item = [FTUIListCellIem itemWithClassString:classes[i] shimmering:NO];
        item.separatorLeftMargin = 14;
        [items addObject:item];
    }
    self.items = items;
}

#pragma mark - rightItemAction
- (void)turnShimmerOn:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"Shimmering"]) {
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(turnShimmerOn:)];
        
        for (NSInteger i = 0; i < self.items.count && i < 1; i++) {
            FTUIListCellIem * item = self.items[i];
            item.shimmering = YES;
        }

        [self.tableView reloadData];
        
    }else {
          self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Shimmering" style:UIBarButtonItemStylePlain target:self action:@selector(turnShimmerOn:)];
        
        for (FTUIListCellIem *item in self.items) {
            item.shimmering = NO;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FTUIListCellId";
    FTUIListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[FTUIListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    FTUIListCellIem *item = self.items[indexPath.row];
    [item setCellWidth:CGRectGetWidth(tableView.bounds)];
    [cell setItem:item];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     FTUIListCellIem *item = self.items[indexPath.row];
    return item.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FTUIListCellIem *item = self.items[indexPath.row];
    Class class = NSClassFromString(item.classString);
    if (class) {
        UIViewController *vc = [[class alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
