/**
 * Tencent is pleased to support the open source community by making MLeaksFinder available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 *
 * https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

#import "NSObject+MemoryLeak.h"
#import "MLeakedObjectProxy.h"
#import "MLeaksFinder.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

#if _INTERNAL_MLF_RC_ENABLED
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>
#endif

static const void *const kViewStackKey = &kViewStackKey;
static const void *const kParentPtrsKey = &kParentPtrsKey;
const void *const kLatestSenderKey = &kLatestSenderKey;

@implementation NSObject (MemoryLeak)

- (BOOL)willDealloc {
    NSString *className = NSStringFromClass([self class]);
    if ([[NSObject classNamesWhitelist] containsObject:className])
        return NO;
    
    NSNumber *senderPtr = objc_getAssociatedObject([UIApplication sharedApplication], kLatestSenderKey);
    if ([senderPtr isEqualToNumber:@((uintptr_t)self)])
        return NO;
    
    __weak id weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong id strongSelf = weakSelf;
        [strongSelf assertNotDealloc];
    });
    
    return YES;
}

- (void)assertNotDealloc {
    if ([MLeakedObjectProxy isAnyObjectLeakedAtPtrs:[self parentPtrs]]) {
        return;
    }
    [MLeakedObjectProxy addLeakedObject:self];
    
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"Possibly Memory Leak.\nIn case that %@ should not be dealloced, override -willDealloc in %@ by returning NO.\nView-ViewController stack: %@", className, className, [self viewStack]);
}

- (void)willReleaseObject:(id)object relationship:(NSString *)relationship {
    if ([relationship hasPrefix:@"self"]) {
        relationship = [relationship stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@""];
    }
    NSString *className = NSStringFromClass([object class]);
    className = [NSString stringWithFormat:@"%@(%@), ", relationship, className];
    
    [object setViewStack:[[self viewStack] arrayByAddingObject:className]];
    [object setParentPtrs:[[self parentPtrs] setByAddingObject:@((uintptr_t)object)]];
    [object willDealloc];
}

- (void)willReleaseChild:(id)child {
    if (!child) {
        return;
    }
    
    [self willReleaseChildren:@[ child ]];
}

- (void)willReleaseChildren:(NSArray *)children {
    NSArray *viewStack = [self viewStack];
    NSSet *parentPtrs = [self parentPtrs];
    for (id child in children) {
        NSString *className = NSStringFromClass([child class]);
        [child setViewStack:[viewStack arrayByAddingObject:className]];
        [child setParentPtrs:[parentPtrs setByAddingObject:@((uintptr_t)child)]];
        [child willDealloc];
    }
}

- (NSArray *)viewStack {
    NSArray *viewStack = objc_getAssociatedObject(self, kViewStackKey);
    if (viewStack) {
        return viewStack;
    }
    
    NSString *className = NSStringFromClass([self class]);
    return @[ className ];
}

- (void)setViewStack:(NSArray *)viewStack {
    objc_setAssociatedObject(self, kViewStackKey, viewStack, OBJC_ASSOCIATION_RETAIN);
}

- (NSSet *)parentPtrs {
    NSSet *parentPtrs = objc_getAssociatedObject(self, kParentPtrsKey);
    if (!parentPtrs) {
        parentPtrs = [[NSSet alloc] initWithObjects:@((uintptr_t)self), nil];
    }
    return parentPtrs;
}

- (void)setParentPtrs:(NSSet *)parentPtrs {
    objc_setAssociatedObject(self, kParentPtrsKey, parentPtrs, OBJC_ASSOCIATION_RETAIN);
}

+ (NSMutableSet *)classNamesWhitelist {
    static NSMutableSet *whitelist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        whitelist = [NSMutableSet setWithObjects:
                     @"UIFieldEditor", // UIAlertControllerTextField
                     @"UINavigationBar",
                     @"_UIAlertControllerActionView",
                     @"_UIVisualEffectBackdropView",
                     nil];
        
        // System's bug since iOS 10 and not fixed yet up to this ci.
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        if ([systemVersion compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            [whitelist addObject:@"UISwitch"];
        }
    });
    return whitelist;
}

+ (void)addClassNamesToWhitelist:(NSArray *)classNames {
    [[self classNamesWhitelist] addObjectsFromArray:classNames];
}

+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
#if _INTERNAL_MLF_ENABLED
    
#if _INTERNAL_MLF_RC_ENABLED
    // Just find a place to set up FBRetainCycleDetector.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [FBAssociationManager hook];
        });
    });
#endif
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        // 添加成功表明当前类添加之前并没有originalSEL这个方法(意味着你尝试替换一个并不存在的方法). 那么执行到此处.已经帮你给这个类添加了originalSEL这个方法.且实现是swizzledMethod的实现.
        
        // 此时虽然尝试执行将 swizzledSEL对应的实现替换为 originalSEL 的, 但是由于 originalSEL 的实现为空, 替换会失败,即 swizzledSEL 的实现仍让为 swizzledSEL 本来的实现. 最终两个不同名的方法, 实现是一样的
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
#endif
}

@end
