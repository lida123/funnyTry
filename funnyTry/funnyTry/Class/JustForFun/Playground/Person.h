//
//  Person.h
//  funnyTry
//
//  Created by SGQ on 2018/3/15.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 matchState (string, optional): 比赛状态
 qtId (string, optional): 球探id ,
 awayTeamLogo (string, optional): 客队图片 ,
 awayTeamId (string, optional): 客队id ,
 homeTeamLogo (string, optional): 主队图片 ,
 homeTeamId (string, optional): 主队id ,
 score (string, optional): 比分 ,
 awayTeamName (integer, optional): 客队名 ,
 homeTeamName (number, optional): 主队名 ,
 matchTime (number, optional): 比赛时间
 */
@interface Person : NSObject

/// 比赛状态
@property (nonatomic, copy) NSString *matchState;

/// 球探id ,
@property (nonatomic, copy) NSString *qtId;

/// 客队图片 ,
@property (nonatomic, copy) NSString *awayTeamLogo;

/// 客队id ,
@property (nonatomic, copy) NSString *awayTeamId;

/// 主队图片 ,
@property (nonatomic, copy) NSString *homeTeamLogo;

/// 主队id ,
@property (nonatomic, copy) NSString *homeTeamId;

/// 比分 ,
@property (nonatomic, copy) NSString *score;

/// 客队名 ,
@property (nonatomic, copy) NSString *awayTeamName;

/// 主队名 ,
@property (nonatomic, copy) NSString *homeTeamName;

/// 比赛时间
@property (nonatomic, copy) NSString *matchTime;

@end
