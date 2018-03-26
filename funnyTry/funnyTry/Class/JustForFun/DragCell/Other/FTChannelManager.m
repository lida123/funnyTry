//
//  FTChannelManager.m
//  funnyTry
//
//  Created by SGQ on 2017/12/12.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTChannelManager.h"
#import "FTChannelCollectionView.h"

@implementation FTChannelManager {
    UINavigationController *_navi;
    FTChannelCollectionView *_collectionView;
    ChanelEndBlock _endBlock;
}

static FTChannelManager *_manager;
+ (instancetype)sharedManager {
    if (!_manager) {
        _manager = [[self alloc] init];
    }
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _collectionView = [[FTChannelCollectionView alloc] initWithFrame:FTScreenBounds];
        
        _navi = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
        _navi.topViewController.view = _collectionView;
        _navi.navigationBar.tintColor = [UIColor blackColor];
        _navi.topViewController.navigationItem.title = @"频道管理";
        _navi.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(finish)];
    }
    return self;
}

- (void)finish {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _navi.view.frame;
        frame.origin.y = - _navi.view.bounds.size.height;
        _navi.view.frame = frame;
    }completion:^(BOOL finished) {
        [_navi.view removeFromSuperview];
        _manager = nil;
    }];
    //_block(_channelView.inUseTitles,_channelView.unUseTitles);
}

- (void)showChannelViewWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles finish:(ChanelEndBlock)block {
    _endBlock = block;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _collectionView.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    [_collectionView reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_navi.view];
    CGRect frame = _navi.view.frame;
    frame.origin.y = -frame.size.height;
    _navi.view.frame = frame;
    _navi.view.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _navi.view.frame;
        frame.origin.y = 0;
        _navi.view.frame = frame;
        _navi.view.alpha = 1;
    }];
}

@end
