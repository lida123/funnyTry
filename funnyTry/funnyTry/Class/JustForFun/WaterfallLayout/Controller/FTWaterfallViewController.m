//
//  FTWaterfallViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/6.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTWaterfallViewController.h"
#import "FTWaterfallLayout.h"
#import "FTPagedScaleLayout.h"
#import "XMGShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"
#import "UIImage+Function.h"

static NSString * const XMGShopId = @"shop";

@interface FTWaterfallViewController () <UICollectionViewDataSource, UICollectionViewDelegate, FTWaterfallLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, strong) UICollectionView *waterfallCollectionView;
@property (nonatomic, strong) UICollectionView *pagedScaleCollectionView;

@end

@implementation FTWaterfallViewController

#pragma mark -Life cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    
    [self setupWaterfallLayout];
    
    [self loadData];
}

#pragma mark -Private
- (void)setupWaterfallLayout
{
    FTWaterfallLayout *layout = [[FTWaterfallLayout alloc] init];
    layout.delegate = self;
    
    _waterfallCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _waterfallCollectionView.backgroundColor = [UIColor whiteColor];
    _waterfallCollectionView.dataSource = self;
    _waterfallCollectionView.delegate = self;
    _waterfallCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_waterfallCollectionView];
    
    [_waterfallCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:XMGShopId];
}

- (void)setupPagedScalefallLayout
{
    FTPagedScaleLayout *lineScaleLayout = [[FTPagedScaleLayout alloc] init];
    
    CGFloat collectionW = self.view.frame.size.width;
    CGFloat collectionH = 200;
    lineScaleLayout.itemSize = CGSizeMake(collectionW - 60, collectionH - 20);
    
    _pagedScaleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 150, collectionW, collectionH) collectionViewLayout:lineScaleLayout];
    _pagedScaleCollectionView.backgroundColor = [UIColor blackColor];;
    _pagedScaleCollectionView.dataSource = self;
    _pagedScaleCollectionView.delegate = self;
    _pagedScaleCollectionView.showsHorizontalScrollIndicator = YES;
    _pagedScaleCollectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.view addSubview:_pagedScaleCollectionView];
    
    [_pagedScaleCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:XMGShopId];
}

- (void)loadData
{
    NSArray *shops = [XMGShop mj_objectArrayWithFilename:@"1.plist"];
    [self.shops removeAllObjects];
    [self.shops addObjectsFromArray:shops];
    
    [self.waterfallCollectionView reloadData];
}

#pragma mark -Click Event
- (void)rightBarButtonItemClicked:(UIBarButtonItem*)item
{
    if (self.waterfallCollectionView.hidden == NO) {
        if (!self.pagedScaleCollectionView) {
            [self setupPagedScalefallLayout];
        }
        
        self.waterfallCollectionView.hidden = YES;
        self.pagedScaleCollectionView.hidden = NO;
    } else  {
        self.waterfallCollectionView.hidden = NO;
        self.pagedScaleCollectionView.hidden = YES;
    }
}

#pragma mark -UISrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!_pagedScaleCollectionView.hidden) {
        FTPagedScaleLayout *lineScaleLayout = (FTPagedScaleLayout*)self.pagedScaleCollectionView.collectionViewLayout;
        [lineScaleLayout scrollViewWillBeginDragging];
    };
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XMGShopId forIndexPath:indexPath];
    XMGShop *shop = self.shops[indexPath.item];
    shop.price = [@(indexPath.item) stringValue];
    cell.shop = shop;
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%zd",indexPath.item);
    if (collectionView == self.pagedScaleCollectionView) {
        FTPagedScaleLayout *layout = (FTPagedScaleLayout*)collectionView.collectionViewLayout;
        if (![layout isItemInTheMiddle:indexPath]) {
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        } else {
            NSLog(@"in the middle");
        }
    }
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
