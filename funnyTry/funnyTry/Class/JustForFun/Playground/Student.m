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

//+ (BOOL)resolveClassMethod:(SEL)sel {
//    return YES;
//}
//
//+ (BOOL) resolveInstanceMethod:(SEL)sel
//{
//    const char *types = sel_getName(sel);
//    class_addMethod([self class], sel, (IMP) dynamicMethodIMP, types);
//    return YES;
//}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [Book new];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    id target = anInvocation.target;
    if ([target isKindOfClass:NSClassFromString(@"Book")]) {
        [anInvocation invokeWithTarget:target];
    }
}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//
//    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
//    if (!signature) {
//        signature = [[NSClassFromString(@"Book") new] methodSignatureForSelector:aSelector];
//    }
//    return signature;
//}

@end
