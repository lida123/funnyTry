//
//  FTDeleteCommentTool.h
//  funnyTry
//
//  Created by SGQ on 2018/8/15.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTDeleteCommentTool : NSObject


// 对于 /* */  这种类型的注释, 如果在项目中存在不规范注释残留, 比如存在 /**/ /*  */ 会导致匹配超出预计目标
- (void)deleteCommentForPath:(NSString *)path;

@end
