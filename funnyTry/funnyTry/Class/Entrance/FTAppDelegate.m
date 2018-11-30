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
#import "YYFPSLabel.h"
#import "BSBacktraceLogger.h"


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

//    [FTAppDelegate findTargetStringForDirectory:@"/Users/wen/Desktop/needX/tips-ios2/Liaodao"];
//    [FTCodeConfuseTool confuseProjectWithChangeFileNameDirectory:@"/Users/wen/Desktop/needX/tips-ios2/Liaodao"
//                                                     pbxprojPath:@"/Users/wen/Desktop/needX/tips-ios2/Liaodao.xcodeproj/project.pbxproj"
//                                         fileNameAppendingPrefix:@"VVVV"
//                                          xcassetsFilesDirectory:@"/Users/wen/Desktop/needX/tips-ios2/Liaodao"
//                                                 garbageCodePath:@"/Users/wen/Documents/GitHub/funnyTry/funnyTry/funnyTry/Class/JustForFun/ChangeFileName/一个实例方法的代码.txt"
//                                 garbageCodeInstanceMethonPrefix:@"VVVV"
//                                               garbageFileCounts:200
//                                                 garbageFileName:@"vvvvuseless"];
    

    
    YYFPSLabel *ftpLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 44, 0, 0 )];
    [ftpLabel sizeToFit];
    [self.window addSubview:ftpLabel];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        BSLOG_MAIN  // 打印主线程调用栈
//    });
    
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
////5555
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


+ (void)findTargetStringForDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:directory error:nil];
    
    BOOL isDirectory;
    for (NSString *fileName in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        
        // 目录则递归
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self findTargetStringForDirectory:filePath];
            continue;
        }
        
        if (![fileName hasSuffix:@".m"]) {
            continue;
        }
        
        // 读取字符串
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (!fileContent) continue;
        
        static NSString * const regexStr = @".*?(SGPageTitleView pageTitleViewWithFrame).*?";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
        
        NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
        if (matches.count > 0) {
            NSLog(@"%@",fileName);
        }
        
    }
}


@end
