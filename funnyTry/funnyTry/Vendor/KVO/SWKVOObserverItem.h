//
//  SWKVOObserverItem.h
//  funnyTry
//
//  Created by SGQ on 2019/3/13.
//  Copyright © 2019年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "NSObject+KVOBlock.h"
NS_ASSUME_NONNULL_BEGIN

@interface SWKVOObserverItem : NSObject
@property(nonatomic, weak) NSObject *observer;  // 注意这里是weak，不会对observer做强引用，这样可以消除 观察者和被观察者间潜在的循环引用
@property(nonatomic, copy) NSString *keyPath;
@property(nonatomic, copy) sw_KVOObserverBlock callback;
@end

NS_ASSUME_NONNULL_END
