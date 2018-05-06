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
#import "FTBaseNavigationController.h"
#import "FTUIListPreViewVC.h"

@interface FTUIListViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation FTUIListViewController

#pragma mark -Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpViews];
    
    [self loadData];
}

#pragma mark -Private
- (void)setUpViews
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Shimmering" style:UIBarButtonItemStylePlain target:self action:@selector(turnShimmerOn:)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)loadData
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *classes = @[@"FTScanViewController",
                         @"FTFlowMountainViewController",
                         @"FTCircleLoadingViewController",
                         @"FTLoginViewController",
                         @"FTCustomPushTransitionFirstVC",
                         @"FTDragCellViewController",
                         @"FTPausePlayAnimationVC",
                         @"FTOneLoadingAnimationVC",
                         @"FTLetterPathViewController",
                         @"FTChangeFileNameVC"];
    
    for (NSInteger i = 0; i < classes.count; i++) {
        FTUIListCellIem *item = [FTUIListCellIem itemWithClassString:classes[i] shimmering:NO];
        item.separatorLeftMargin = 14;
        [items addObject:item];
    }
    self.items = items;
}


#pragma mark - Click Event
- (void)turnShimmerOn:(UIBarButtonItem *)item
{
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

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"FTUIListCellId";
    FTUIListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[FTUIListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    FTUIListCellIem *item = self.items[indexPath.row];
    [item setCellWidth:CGRectGetWidth(tableView.bounds)];
    [cell setItem:item];
    
    if ([self respondsToSelector:@selector(traitCollection)] && [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTUIListCellIem *item = self.items[indexPath.row];
    return item.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FTUIListCellIem *item = self.items[indexPath.row];
    Class class = NSClassFromString(item.classString);
    if (class) {
        UIViewController *vc = [[class alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -UIViewControllerPreviewingDelegate
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell*)[previewingContext sourceView]];
    FTUIListCellIem *item = self.items[indexPath.row];
    FTUIListPreViewVC *previewVC = [[FTUIListPreViewVC alloc] init];
    previewVC.item = item;
    previewingContext.sourceRect = CGRectMake(0, 0, previewingContext.sourceView.frame.size.width, previewingContext.sourceView.frame.size.height);
    return previewVC;
}

@end
