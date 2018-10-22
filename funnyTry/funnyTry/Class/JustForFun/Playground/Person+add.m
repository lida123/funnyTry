//
//  Person+add.m
//  funnyTry
//
//  Created by SGQ on 2018/10/10.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "Person+add.h"
#import <objc/runtime.h>

@implementation Person (add)

- (void)setFemale:(BOOL)female {
    objc_setAssociatedObject(self, @selector(female), [NSNumber numberWithBool:female], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)female {
  return  [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
