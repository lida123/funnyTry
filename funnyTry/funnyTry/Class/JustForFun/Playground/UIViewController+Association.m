//
//  UIViewController+Association.m
//  funnyTry
//
//  Created by SGQ on 2018/7/26.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "UIViewController+Association.h"
#import <objc/runtime.h>



@implementation UIViewController (Association)

- (NSString *)associatedObject_assign {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAssociatedObject_assign:(NSString *)associatedObject_assign {
    objc_setAssociatedObject(self, @selector(associatedObject_assign), associatedObject_assign, OBJC_ASSOCIATION_ASSIGN);
}
- (NSString *)associatedObject_retain {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAssociatedObject_retain:(NSString *)associatedObject_retain {
    objc_setAssociatedObject(self, @selector(associatedObject_retain), associatedObject_retain, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)associatedObject_copy {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAssociatedObject_copy:(NSString *)associatedObject_copy {
    objc_setAssociatedObject(self, @selector(associatedObject_copy), associatedObject_copy, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
