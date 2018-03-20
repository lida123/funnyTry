//
//  Student.h
//  funnyTry
//
//  Created by SGQ on 2018/3/15.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "Person.h"

@interface Student : Person

@property (nonatomic, strong) NSArray *books;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, assign) BOOL fashionable;
@end
