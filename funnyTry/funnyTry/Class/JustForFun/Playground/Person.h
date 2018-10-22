//
//  Person.h
//  funnyTry
//
//  Created by SGQ on 2018/3/15.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    int _gg;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, assign) NSUInteger count;
@end
