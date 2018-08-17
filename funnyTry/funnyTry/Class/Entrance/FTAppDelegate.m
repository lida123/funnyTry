//
//  AppDelegate.m
//  funnyTry
//
//  Created by SGQ on 2017/10/31.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTTabBarController.h"
#import "FTCodeConfuseTool.h"

@interface FTAppDelegate ()

@end

@implementation FTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    FTTabBarController *tabBarController = [[FTTabBarController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
  
    [FTCodeConfuseTool confuseProjectWithChangeFileNameDirectory:@"/Users/wen/Desktop/needX/NOEETY/NOEETY/Classes"
                                                    pbxprojPath:@"/Users/wen/Desktop/needX/NOEETY/NOEETY.xcodeproj/project.pbxproj"
                                         fileNameAppendingPrefix:@"GQGQ"
                                          xcassetsFilesDirectory:@"/Users/wen/Desktop/needX/NOEETY/NOEETY"
                                                 garbageCodePath:@"/Users/wen/Documents/GitHub/funnyTry/funnyTry/funnyTry/Class/JustForFun/ChangeFileName/一个实例方法的代码.txt"
                                 garbageCodeInstanceMethonPrefix:@"GQGQ"
                                               garbageFileCounts:20
                                                 garbageFileName:@"godbless"];
    
    return YES;
}

- (UIFont *)font {
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:@"BebasNeue" ofType:@"otf"];
    NSURL *url = [NSURL fileURLWithPath:fontPath];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    if (fontDataProvider == NULL)        return nil;
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    if (newFont == NULL) return nil;
    NSString *fontName = (__bridge NSString *)CGFontCopyFullName(newFont);
    UIFont *font = [UIFont fontWithName:fontName size:12];
    CGFontRelease(newFont);
    return font;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%s",__func__);
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%s",__func__);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%s",__func__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%s",__func__);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

@end
