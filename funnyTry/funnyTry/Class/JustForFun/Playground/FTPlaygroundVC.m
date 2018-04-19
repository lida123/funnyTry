//
//  FTPlaygroundVC.m
//  funnyTry
//
//  Created by SGQ on 2018/4/19.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTPlaygroundVC.h"
#import "Person.h"
#import "Student.h"
#import "Book.h"
#import "MJExtension.h"

@interface FTPlaygroundVC ()

@end

@implementation FTPlaygroundVC

- (void)viewDidLoad
{
    self.navigationItem.title = @"Have fun";

    NSDictionary *dic = @{@"school":@"qinghua",@"books":@[@"yuwen",@"shuxue"],@"name":@"HuWeiwei",@"age":@25,@"fashionable":@2,@"pointer":@"0x1111111111",@"id":@"idName"};
    Student *student = [Student mj_objectWithKeyValues:dic];
    
    //    Book *book = [Book mj_objectWithKeyValues:dic];
    return;
}
@end
