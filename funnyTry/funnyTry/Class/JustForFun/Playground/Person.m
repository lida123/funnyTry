
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
    NSLog(@"Person test");
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"qtId"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey: key];
}

@end
