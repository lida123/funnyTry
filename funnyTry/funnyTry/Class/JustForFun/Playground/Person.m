
//
//  Person.m
//  funnyTry
//
//  Created by SGQ on 2018/3/15.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "Person.h"
#import "MJExtension.h"

@implementation Person

- (void)test {
    NSLog(@"person test");
}

- (NSObject *)mayleak {
    NSObject *obj = [NSObject new];
    return obj;
}
@end
