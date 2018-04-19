//
//  Student.m
//  funnyTry
//
//  Created by SGQ on 2018/3/15.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "Student.h"
#import "MJExtension.h"

@implementation Student
MJLogAllIvars

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"books":@"Book"};
}

//+ (NSArray *)mj_allowedPropertyNames {
//    return @[@"books",@"school"];
//}
//
//- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
//    if ([property.name isEqualToString:@"school"] && [oldValue isEqualToString:@"qinghua"]) {
//        return @"beida";
//    }
//    return oldValue;
//}

@end
