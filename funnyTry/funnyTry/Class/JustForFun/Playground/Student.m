//
//  Student.m
//  funnyTry
//
//  Created by SGQ on 2018/3/15.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "Student.h"
#import "MJExtension.h"
#import "Book.h"

void dynamicMethodIMP(id self, SEL _cmd)
{
    NSLog(@"testsssssssssss");
}

@implementation Student

- (void)speakWithAword:(NSString *)word {
    NSLog(@"word");
}

@end
