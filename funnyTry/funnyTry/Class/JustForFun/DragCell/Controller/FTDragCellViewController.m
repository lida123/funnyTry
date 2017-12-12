//
//  FTDragCellViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/12/12.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTDragCellViewController.h"
#import "FTChannelManager.h"

@interface FTDragCellViewController ()

@end

@implementation FTDragCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showChannelView)];
}

- (void)showChannelView {
    NSArray *arr1 = @[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"];
    NSArray *arr2 = @[@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索",@"综艺",@"美食",@"育儿"];
    [[FTChannelManager sharedManager] showChannelViewWithInUseTitles:arr1 unUseTitles:arr2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        NSLog(@"inUseTitles = %@",inUseTitles);
        NSLog(@"unUseTitles = %@",unUseTitles);
    }];
}

@end
