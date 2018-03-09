//
//  FTWaterfallViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTWaterfallViewController.h"
#import "FTWaterfallLayout.h"
#import "XMGShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"

@interface FTWaterfallViewController () <UICollectionViewDataSource, FTWaterfallLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation FTWaterfallViewController

static NSString * const XMGShopId = @"shop";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shops = [NSMutableArray array];
    
    [self setupLayout];
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
}

- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [XMGShop objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
    });
}

- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [XMGShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        
        [self.collectionView.footer endRefreshing];
    });
}

- (void)setupLayout
{
    FTWaterfallLayout *layout = [[FTWaterfallLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:XMGShopId];
    
    self.collectionView = collectionView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XMGShopId forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
    return cell;
}

#pragma mark - <XMGWaterflowLayoutDelegate>
- (CGFloat)waterfallLayout:(FTWaterfallLayout *)waterfallLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    if (indexPath.item < self.shops.count) {
        XMGShop *shop = self.shops[indexPath.item];
        return itemWidth * shop.h / shop.w;
    }
    return 1;
}

- (CGFloat)rowMarginInWaterfallLayout:(FTWaterfallLayout *)waterfallLayout
{
    return 20;
}

- (CGFloat)columnMarginInWaterfallLayout:(FTWaterfallLayout *)waterfallLayout
{
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterfallLayout:(FTWaterfallLayout *)waterfallLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
