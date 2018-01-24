//
//  FTCornerRadiusController.m
//  funnyTry
//
//  Created by SGQ on 2018/1/10.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTCornerRadiusController.h"
#import "FTCornerRadiusCell.h"

@interface FTCornerRadiusController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FTCornerRadiusController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FTUIListCellId";
    FTCornerRadiusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[FTCornerRadiusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.image = [UIImage imageNamed:@"NOEEK3BtnRedBack"];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 40, 40)];
    imageView1.image = [UIImage imageNamed:@"NOEEK3BtnRedBack"];
    imageView1.layer.cornerRadius = 20;
    imageView1.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 40, 40)];
    imageView2.image = [UIImage imageNamed:@"NOEEK3BtnRedBack"];
    imageView2.layer.cornerRadius = 20;
    imageView2.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 0, 40, 40)];
    imageView3.image = [UIImage imageNamed:@"NOEEK3BtnRedBack"];
    imageView3.layer.cornerRadius = 20;
    imageView3.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView3];
    
    return cell;
}

@end
