//
//  FTChannelCollectionView.m
//  funnyTry
//
//  Created by SGQ on 2017/12/12.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTChannelCollectionView.h"
#import "FTChannelCollectionViewCell.h"
#import "FTChannelHeaderView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface FTChannelCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView * _collectionView;
    NSIndexPath *_dragingIndexPath;
    
    FTChannelCollectionViewCell *_dragingCell;
}
@end

@implementation FTChannelCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        NSUInteger countPerRow = 4;
        CGFloat hx_space = 15;
        CGFloat vx_space = 10;
        CGFloat w = (frame.size.width - (countPerRow - 1 +2) * hx_space) / countPerRow;
        layout.itemSize = CGSizeMake(w, w / 2.0);
        layout.minimumLineSpacing = hx_space;
        layout.minimumInteritemSpacing = vx_space;
        layout.headerReferenceSize =  CGSizeMake(frame.size.width,40);
        layout.sectionInset = UIEdgeInsetsMake(vx_space, hx_space, vx_space, hx_space);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        
        [_collectionView registerClass:[FTChannelCollectionViewCell class] forCellWithReuseIdentifier:@"FTChannelCollectionViewCellID"];
        [_collectionView registerClass:[FTChannelHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FTChannelHeaderViewID"];
        [self addSubview:_collectionView];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.3;
        [_collectionView addGestureRecognizer:longPress];
        
        _dragingCell = [[FTChannelCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height)];
        _dragingCell.hidden = YES;
        [_collectionView addSubview:_dragingCell];
    }
    return self;
}

- (void)longPress:(UILongPressGestureRecognizer*)longPress {
    CGPoint p = [longPress locationInView:longPress.view];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self dragStartWithPoint:p];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            [self dragChangeWithPoint:p];
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self dragEndWithPoint:p];
        }
            break;
        default:
            break;
    }
}

- (void)dragStartWithPoint:(CGPoint)p{
    _dragingIndexPath = [self dragingPathWithPoint:p];
    if (!_dragingIndexPath) {
        return;
    }
    
    FTChannelCollectionViewCell *cell = (FTChannelCollectionViewCell*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    cell.isMoving = YES;
    _dragingCell.title = cell.title;
    _dragingCell.center = cell.center;
    _dragingCell.transform = CGAffineTransformMakeScale(1.1, 1.1);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    _dragingCell.hidden = NO;
}

- (void)dragChangeWithPoint:(CGPoint)p{
    if (!_dragingIndexPath) {
        return;
    }
    _dragingCell.center = p;
    
    NSIndexPath *targetIndexPath = [self targetIndexPathWithPoint:p];
    if (!targetIndexPath) {
        return;
    }
    
    [self exchangeItemForIndexPath1:_dragingIndexPath indexPath2:targetIndexPath];
    [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:targetIndexPath];
    _dragingIndexPath = targetIndexPath;
}

- (void)dragEndWithPoint:(CGPoint)p{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        _dragingCell.frame = endFrame;
    }completion:^(BOOL finished) {
        _dragingCell.hidden = true;
        FTChannelCollectionViewCell *cell = (FTChannelCollectionViewCell*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
        cell.isMoving = false;
    }];
}

- (NSIndexPath*)dragingPathWithPoint:(CGPoint)point {
    NSIndexPath *dragIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        if (indexPath.section == 1 || (indexPath.section == 0 && indexPath.row == 0)) {
            continue;
        }

        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            dragIndexPath = indexPath;
            break;
        }
    }
    return dragIndexPath;
}

- (NSIndexPath *)targetIndexPathWithPoint:(CGPoint)point {
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        if (indexPath.section == 1 || (indexPath.section == 0 && indexPath.row == 0)) {
            continue;
        }
        
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point) && ![indexPath isEqual:_dragingIndexPath]) {
            targetIndexPath = indexPath;
            break;
        }
    }
    return targetIndexPath;
}

- (void)exchangeItemForIndexPath1:(NSIndexPath*)indexPath1 indexPath2:(NSIndexPath*)indexPath2 {
    if ([_collectionView.indexPathsForVisibleItems containsObject:indexPath1] && [_collectionView.indexPathsForVisibleItems containsObject:indexPath2]) {
        [_inUseTitles exchangeObjectAtIndex:indexPath1.row withObjectAtIndex:indexPath2.row];
    }
}

- (void)reloadData {
    [_collectionView reloadData];
}

#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section == 0 ? _inUseTitles.count : _unUseTitles.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FTChannelHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FTChannelHeaderViewID" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.title = @"已选频道";
        headerView.subTitle = @"按住拖动调整排序";
    }else{
        headerView.title = @"推荐频道";
        headerView.subTitle = @"";
    }
    return headerView;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FTChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FTChannelCollectionViewCellID" forIndexPath:indexPath];
    NSString *title = nil;
    if (indexPath.section == 0) {
        title = self.inUseTitles[indexPath.row];
    }else if(indexPath.section == 1){
        title = self.unUseTitles[indexPath.row];
    }
    cell.title = title;
    cell.isFixed = indexPath.section == 0 && indexPath.row == 0;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return;
        }
        
        id obj = [self.inUseTitles objectAtIndex:indexPath.row];
        [self.unUseTitles insertObject:obj atIndex:0];
        [self.inUseTitles removeObject:obj];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
    }else if (indexPath.section == 1) {
        id obj = [self.unUseTitles objectAtIndex:indexPath.row];
        [self.inUseTitles insertObject:obj atIndex:0];
        [self.unUseTitles removeObject:obj];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.inUseTitles.count - 1 inSection:0]];
    }
}

@end
