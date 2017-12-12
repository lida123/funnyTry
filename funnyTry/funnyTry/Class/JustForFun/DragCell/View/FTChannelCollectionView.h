//
//  FTChannelCollectionView.h
//  funnyTry
//
//  Created by SGQ on 2017/12/12.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTChannelCollectionView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;

@property (nonatomic,strong) NSMutableArray *unUseTitles;

-(void)reloadData;

@end
