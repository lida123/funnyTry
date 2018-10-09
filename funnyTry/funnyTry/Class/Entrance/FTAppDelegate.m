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
  
//    [FTCodeConfuseTool confuseProjectWithChangeFileNameDirectory:@"/Users/wen/Desktop/needX/tips-ios/Liaodao/Classes"
//                                                    pbxprojPath:@"/Users/wen/Desktop/needX/tips-ios/Liaodao.xcodeproj/project.pbxproj"
//                                         fileNameAppendingPrefix:@"GQGQ"
//                                          xcassetsFilesDirectory:@"/Users/wen/Desktop/needX/tips-ios/Liaodao/Resource/Image"
//                                                 garbageCodePath:@"/Users/wen/Documents/GitHub/funnyTry/funnyTry/funnyTry/Class/JustForFun/ChangeFileName/一个实例方法的代码.txt"
//                                 garbageCodeInstanceMethonPrefix:@"GQGQ"
//                                               garbageFileCounts:500
//                                                 garbageFileName:@"godbless"];
//    [FTCodeConfuseTool changeXcassetsFilesForDirectory:@"/Users/wen/Desktop/needX/tips-ios/Liaodao/Resource/Image"];
    
//    CGFloat components[3];
//    CFTimeInterval t0 = CFAbsoluteTimeGetCurrent();
//    for (NSInteger i = 0; i < 100000; i++) {
//          [self P_getRGBComponents:components forColor:[UIColor grayColor]];
//    }
//    CFTimeInterval t1 = CFAbsoluteTimeGetCurrent();
//
//
//    CFTimeInterval t2 = CFAbsoluteTimeGetCurrent();
//    for (NSInteger i = 0; i < 100000; i++) {
//        [self P2_getRGBComponents:components forColor:[UIColor grayColor]];
//    }
//    CFTimeInterval t3 = CFAbsoluteTimeGetCurrent();
//
//    NSLog(@"%f",(t1-t0)/(t3-t2));
    NSLog(@"-----%zd-----", @"09991".integerValue);
    
    return YES;
}
/// 1111
- (void)P_getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}
////22222
//33333
////444
- (void)P2_getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    components[0] = red;
    components[1] = green;
    components[2] = blue;
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
