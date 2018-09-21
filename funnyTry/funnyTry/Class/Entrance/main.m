//
//  main.m
//  funnyTry
//
//  Created by SGQ on 2017/10/31.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTAppDelegate.h"

#define XLink(n) x##n

int main(int argc, char * argv[])
{
    @autoreleasepool {
        int x1 = 1;int x2 = 2;int x3 = 3;
        NSLog(@"%zd",x1);
        NSLog(@"%zd",XLink(2));
        NSLog(@"%zd",x2);
        NSLog(@"%zd",XLink(3));
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([FTAppDelegate class]));
    }
}
