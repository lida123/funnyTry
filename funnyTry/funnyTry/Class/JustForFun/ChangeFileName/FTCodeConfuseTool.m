//
//  FTCodeConfuseTool.m
//  funnyTry
//
//  Created by SGQ on 2018/8/16.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTCodeConfuseTool.h"

// 文件重命名
static void renameFile(NSString *oldPath, NSString *newPath) {
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:oldPath toPath:newPath error:&error];
    if (error) {
        printf("修改文件名称失败。\n  oldPath=%s\n  newPath=%s\n  ERROR:%s\n", oldPath.UTF8String, newPath.UTF8String, error.localizedDescription.UTF8String);
    }
}

// 正则替换字符串
static BOOL regularReplacement(NSMutableString *originalString, NSString *regularExpression, NSString *newString) {
    __block BOOL isChanged = NO;
    BOOL isGroupNo1 = [newString isEqualToString:@"\\1"];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:originalString options:0 range:NSMakeRange(0, originalString.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isChanged) {
            isChanged = YES;
        }
        if (isGroupNo1) {
            NSString *withString = [originalString substringWithRange:[obj rangeAtIndex:1]];
            [originalString replaceCharactersInRange:obj.range withString:withString];
        } else {
            [originalString replaceCharactersInRange:obj.range withString:newString];
        }
    }];
    return isChanged;
}

// 将目标目录下所有文件中 oldClassName->newClassName
static void replaceOldClassNameInFileContent(NSString *targetDirectory, NSString *oldClassName, NSString *newClassName) {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:targetDirectory error:nil];
    BOOL isDirectory;
    for (NSString *filePath in files) {
        NSString *path = [targetDirectory stringByAppendingPathComponent:filePath];
        if ([fm fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory) {
            replaceOldClassNameInFileContent(path, oldClassName, newClassName);
            continue;
        }
        
        NSString *fileName = filePath.lastPathComponent;
        if ([fileName hasSuffix:@".h"] || [fileName hasSuffix:@".m"] || [fileName hasSuffix:@".pch"]|| [fileName hasSuffix:@".xib"] || [fileName hasSuffix:@".storyboard"]) {
            
            NSError *error = nil;
            NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"打开文件 %@ 失败：%@\n", path, error.localizedDescription);
                continue;
            }
            
            NSString *regularExpression = [NSString stringWithFormat:@"\\b%@\\b", oldClassName];
            BOOL isChanged = regularReplacement(fileContent, regularExpression, newClassName);
            if (!isChanged) {continue;}
            
            error = nil;
            [fileContent writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"保存文件 %@ 失败：%@\n", path, error.localizedDescription);
            }
        }
    }
}


@implementation FTCodeConfuseTool

#pragma mark - 修改文件名
+ (void)changeFileNameForDirectory:(NSString *)dir pbxprojPath:(NSString *)pbxprojPath appendingPrefix:(NSString *)appendingPrefix {
    NSFileManager *fm = [NSFileManager defaultManager];
 
    NSEnumerator *fileEnumerator = [fm enumeratorAtPath:dir];
    if (!fileEnumerator) {
        NSLog(@"目录无效");
        return;
    }
    
    // 项目的 project.pbxproj
    NSError *error;
    NSMutableString *xcodeprojContent = [NSMutableString stringWithContentsOfFile:pbxprojPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"打开工程文件 %@ 失败：%@\n", pbxprojPath, error.localizedDescription);
        return;
    }
    
    NSArray *canChangeFilePaths = [self pickoutCanChangeFileNameForDirectory:dir];
    NSLog(@"可以更改名称的文件数量: %zd", canChangeFilePaths.count);
    
    NSInteger count = 0;
    NSMutableSet *changedFileNames = [NSMutableSet set];
    for (NSString *oldFilePath in canChangeFilePaths) {
        @autoreleasepool {
            count++;
            NSLog(@"正在处理第 %zd 个文件", count);
            
            NSString *oldFileNameWithoutExt = oldFilePath.lastPathComponent.stringByDeletingPathExtension;
            NSString *newFileNameWithoutExt = [NSString stringWithFormat:@"%@%@",appendingPrefix,oldFileNameWithoutExt];
            
            NSString *fileExt = oldFilePath.pathExtension;
            NSString *newFilePath = [NSString stringWithFormat:@"%@/%@.%@", oldFilePath.stringByDeletingLastPathComponent, newFileNameWithoutExt, fileExt];
            
            // 修改文件名并
            renameFile(oldFilePath, newFilePath);
            
            if (![changedFileNames containsObject:oldFileNameWithoutExt]) {
                [changedFileNames addObject:oldFileNameWithoutExt];
                
                // 修改文件内容
                replaceOldClassNameInFileContent(dir, oldFileNameWithoutExt, newFileNameWithoutExt);
                
                // 修改工程文件中的文件名
                NSString *regularExpression = [NSString stringWithFormat:@"\\b%@\\b", oldFileNameWithoutExt];
                regularReplacement(xcodeprojContent, regularExpression, newFileNameWithoutExt);
            }
            
        } // @autoreleasepool end
    }
    
    [xcodeprojContent writeToFile:pbxprojPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"文件名修改完成");
}

// 挑选出可以进行改名操作的文件
+ (NSArray *)pickoutCanChangeFileNameForDirectory:(NSString *)dir {
    NSSet *cannotChangeFileNames = [self pickoutCannotChangeFileNameForDirectory:dir];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSEnumerator *fileEnumerator = [fm enumeratorAtPath:dir];
    NSMutableArray *canChangeFilePaths = [NSMutableArray array];
    
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [dir stringByAppendingPathComponent:fileName];
        NSString *lastPathWithoutExt = [fileName.lastPathComponent stringByDeletingPathExtension];
        
        // 分类不能修改
        if ([lastPathWithoutExt containsString:@"+"]) {
            continue;
        }
        
        // 暂时支持修改.h .m .xib
        if ([fileName containsString:@".h"] || [fileName containsString:@".m"] || [fileName containsString:@".xib"]){
            if (![cannotChangeFileNames containsObject:lastPathWithoutExt]) {
                [canChangeFilePaths addObject:filePath];
            }
        }
    }
    
    return canChangeFilePaths;
}

// 不可修改的文件名(分类和xib)
+ (NSSet *)pickoutCannotChangeFileNameForDirectory:(NSString *)dir {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSEnumerator *fileEnumerator = [fm enumeratorAtPath:dir];
    NSMutableSet *set = [NSMutableSet set];
    
    [set addObject:@"main"];
    [set addObject:@"easing"];
    
    for (NSString *fileName in fileEnumerator) {
        NSString *lastPathWithoutExt = [fileName.lastPathComponent stringByDeletingPathExtension];
        
        // 如果是一个category文件, 那么相关的.h.m都不修改了
        if ([fileName containsString:@"+"]) {
            NSArray *com = [lastPathWithoutExt componentsSeparatedByString:@"+"];
            [set addObject:com[0]];
            [set addObject:com[1]];
        }
    }
    return set;
}

#pragma mark - 修改 xxx.xcassets 文件夹中的 png 资源文件名。
static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
NSString *randomString(NSInteger length) {
    NSMutableString *ret = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [ret appendFormat:@"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((uint32_t)[kRandomAlphabet length])]];
    }
    return ret;
}

+ (void)changeXcassetsFilesForDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:directory error:nil];
    
    BOOL isDirectory;
    for (NSString *fileName in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        
        // 目录则递归
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self changeXcassetsFilesForDirectory:filePath];
            continue;
        }
        
        // 当前文件是Contents.json且在一个.imageset目录下
        if (![fileName isEqualToString:@"Contents.json"]) continue;
        NSString *contentsDirectoryName = filePath.stringByDeletingLastPathComponent.lastPathComponent;
        if (![contentsDirectoryName hasSuffix:@".imageset"]) continue;
        
        // 读取字符串
        NSString *fileContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (!fileContent) continue;
        
        NSMutableArray<NSString *> *processedImageFileNameArray = @[].mutableCopy;
        
        static NSString * const regexStr = @"\"filename\" *: *\"(.*)?\"";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionUseUnicodeWordBoundaries error:nil];
        
        NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
        while (matches.count > 0) {
            NSInteger i = 0;
            NSString *imageFileName = nil;
            
            // 退出外层循环条件(即正则匹配出来的文件名都被处理过了则退出循环)
            do {
                if (i >= matches.count) {
                    i = -1;
                    break;
                }
                imageFileName = [fileContent substringWithRange:[matches[i] rangeAtIndex:1]];
                i++;
            } while ([processedImageFileNameArray containsObject:imageFileName]);
            if (i < 0) break;
            
            // 更改文件名并重写json文件
            NSString *imageFilePath = [filePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:imageFileName];
            if ([fm fileExistsAtPath:imageFilePath]) {
                NSString *newImageFileName = [randomString(10) stringByAppendingPathExtension:imageFileName.pathExtension];
                NSString *newImageFilePath = [filePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:newImageFileName];
                while ([fm fileExistsAtPath:newImageFileName]) {
                    newImageFileName = [randomString(10) stringByAppendingPathExtension:imageFileName.pathExtension];
                    newImageFilePath = [filePath.stringByDeletingLastPathComponent stringByAppendingPathComponent:newImageFileName];
                }
                // 修改文件名
                NSError *error;
                [[NSFileManager defaultManager] moveItemAtPath:imageFilePath toPath:newImageFilePath error:&error];
                if (error) {
                    NSLog(@"修改文件名出错! %@ >>>> %@", imageFilePath, newImageFilePath);
                }
                
                // 重写json
                fileContent = [fileContent stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"\"%@\"", imageFileName] withString:[NSString stringWithFormat:@"\"%@\"", newImageFileName]];
                [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                [processedImageFileNameArray addObject:newImageFileName];
            } else {
                [processedImageFileNameArray addObject:imageFileName];
            }
            
            // 再来
            matches = [expression matchesInString:fileContent options:0 range:NSMakeRange(0, fileContent.length)];
        }
    }
}

#pragma mark - 给每一个.m文件增加垃圾代码
+ (void)addGarbageCodeInEachMFileForDirectory:(NSString *)directory garbageCodePath:(NSString *)garbageCodePath instanceMethonPrefix:(NSString *)instanceMethonPrefix {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSEnumerator *enumerator = [fm enumeratorAtPath:directory];
    if (!enumerator) {
        NSLog(@"目录无效");
    }
    
    if (!instanceMethonPrefix.length) {
        NSLog(@"无效方法前缀");
    }
    

    NSString *garbageCode = [NSString stringWithContentsOfFile:garbageCodePath encoding:NSUTF8StringEncoding error:nil];
    if (!garbageCode.length) {
        NSLog(@"垃圾代码为空");
        return;
    }
    
    for (NSString *path in enumerator) {
        NSString *abPath = [directory stringByAppendingPathComponent:path];
        if ([abPath containsString:@".m"]) {
          
            NSError *error;
            NSMutableString *contentM = [NSMutableString stringWithContentsOfFile:abPath encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"读取文件内容出错: %@ \n",error.localizedDescription);
                continue;
            }
            
            NSRange endRange = [contentM rangeOfString:@"@end" options:NSBackwardsSearch range:NSMakeRange(0, contentM.length)];
            if (endRange.location != NSNotFound) {
                [contentM replaceCharactersInRange:endRange withString:[self extendGarbageCode:garbageCode instanceMethonPrefix:instanceMethonPrefix]];
                
                [contentM appendString:@"\n@end"];
            }
            
            [contentM writeToFile:abPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    
    NSLog(@"添加垃圾代码完成");
}

static NSInteger count = 0;
+ (NSString *)extendGarbageCode:(NSString *)origalCode instanceMethonPrefix:(NSString *)instanceMethonPrefix{
    NSMutableString *string = [NSMutableString string];
    /**
     - (NSString *)mj_underlineFromCamel11
     {
     */
    NSString * regularExpression = @"^-.*?\\)(.*?)\\s?\\{";
    NSString *methonName = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:origalCode options:0 range:NSMakeRange(0, origalCode.length)];
    if (matches.count > 0) {
        NSTextCheckingResult *result = [matches firstObject];
        methonName = [origalCode substringWithRange:[result rangeAtIndex:1]];
    }
    
    if (methonName) {
        for (NSInteger i = 0; i < 20; i++) {
            count++;
            NSString *newMethonName = [NSString stringWithFormat:@"%@_%ld%@",instanceMethonPrefix,(long)count, methonName];
            
            NSString *newCode = [origalCode stringByReplacingOccurrencesOfString:methonName withString:newMethonName];
            
            [string appendString:newCode];
        }
        
        return string;
    }

    return origalCode;
}

#pragma makr - 添加垃圾文件
+ (void)addGarbageFilesInDirectory:(NSString *)directory fileCounts:(NSInteger)count fileName:(NSString *)fileName garbageCodePath:(NSString *)garbageCodePath instanceMethonPrefix:(NSString *)instanceMethonPrefix {

    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dirPath = [directory stringByAppendingPathComponent:@"GarbageFiles"];
    NSError *error;
    [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!error) {
        NSLog(@"创建垃圾文件目录成功");
    } else {
        NSLog(@"创建垃圾文件目录失败");
        return;
    }
    
    
    NSString *garbageCode = [NSString stringWithContentsOfFile:garbageCodePath encoding:NSUTF8StringEncoding error:nil];
    if (!garbageCode.length) {
        NSLog(@"垃圾代码为空");
        return;
    }
    
    NSString *lastFileName = nil;
    for (NSInteger i = 0; i < count; i++) {
        NSString *eachFileName = [NSString stringWithFormat:@"%@%zd",fileName,i];
        NSString*extentGarbageCode = [self extendGarbageCode:garbageCode instanceMethonPrefix:instanceMethonPrefix];
        
        [self createOneFileWithFileName:eachFileName atdirPath:dirPath lastFileName:lastFileName garbageCode:extentGarbageCode];
        lastFileName = eachFileName;
    }
    
    NSLog(@"添加垃圾文件完成");
}

/*
 #import <Foundation/Foundation.h>
 
 @interface MoreViewTest : NSObject
 
 @end
 
 
 
 #import "MoreViewTest.h"
 
 @implementation MoreViewTest
 
 */
+ (void)createOneFileWithFileName:(NSString *)fileName atdirPath:(NSString *)dirPath lastFileName:(NSString *)lastFileName garbageCode:(NSString *)garbageCode{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *hString = [NSString stringWithFormat:@"#import <Foundation/Foundation.h> \n@interface %@ : NSObject \n@end",fileName];
    NSString *hPath = [NSString stringWithFormat:@"%@/%@.h",dirPath,fileName];
    [fm createFileAtPath:hPath contents:[hString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    NSString *mString = nil;
    NSString *appendString = [NSString stringWithFormat:@"%@\n@end",garbageCode];
    if (!lastFileName) {
        mString = [NSString stringWithFormat:@"#import \"%@.h\" \n@implementation %@ \n %@",fileName,fileName,appendString];
    } else {
        mString = [NSString stringWithFormat:@"#import \"%@.h\" \n#import \"%@.h\"  \n@implementation %@ \n %@",fileName,lastFileName,fileName,appendString];
    }
    NSString *mPath = [NSString stringWithFormat:@"%@/%@.m",dirPath,fileName];
    [fm createFileAtPath:mPath contents:[mString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
}

#pragma mark - 删除项目中的注释
+ (void)deleteCommentForDirectory:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray<NSString *> *files = [fm contentsOfDirectoryAtPath:directory error:nil];
    BOOL isDirectory;
    for (NSString *fileName in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:fileName];
        // 目录则递归
        if ([fm fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory) {
            [self deleteCommentForDirectory:filePath];
            continue;
        }
        
        // 文件则修改
        if (![fileName hasSuffix:@".h"] && ![fileName hasSuffix:@".m"]) continue;
        NSMutableString *fileContent = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        //
        deleteCommentRegularReplacement(fileContent, @"([^:/])//.*",             @"\\1");
        deleteCommentRegularReplacement(fileContent, @"^//.*",                   @"");
        deleteCommentRegularReplacement(fileContent, @"/\\*{1,2}[\\s\\S]*?\\*/", @""); //  /\*{1,2}[\s\S]*?\*/
        deleteCommentRegularReplacement(fileContent, @"^\\s*\\n",                @""); //  ^\\s*\\n
        [fileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

BOOL deleteCommentRegularReplacement(NSMutableString *originalString, NSString *regularExpression, NSString *newString) {
    __block BOOL isChanged = NO;
    BOOL isGroupNo1 = [newString isEqualToString:@"\\1"];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionAnchorsMatchLines|NSRegularExpressionUseUnixLineSeparators error:nil];
    NSArray<NSTextCheckingResult *> *matches = [expression matchesInString:originalString options:0 range:NSMakeRange(0, originalString.length)];
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!isChanged) {
            isChanged = YES;
        }
        if (isGroupNo1) {
            NSString *withString = [originalString substringWithRange:[obj rangeAtIndex:1]];
            [originalString replaceCharactersInRange:obj.range withString:withString];
        } else {
            [originalString replaceCharactersInRange:obj.range withString:newString];
        }
    }];
    return isChanged;
}

#pragma mark - 综合
+ (void)confuseProjectWithChangeFileNameDirectory:(NSString *)ChangeFileNameDirectory pbxprojPath:(NSString *)pbxprojPath fileNameAppendingPrefix:(NSString *)fileNameAppendingPrefix xcassetsFilesDirectory:(NSString *)xcassetsFilesDirectory garbageCodePath:(NSString *)garbageCodePath garbageCodeInstanceMethonPrefix:(NSString *)garbageCodeInstanceMethonPrefix garbageFileCounts:(NSInteger)garbageFileCounts garbageFileName:(NSString *)garbageFileName {
    
    [self changeFileNameForDirectory:ChangeFileNameDirectory pbxprojPath:pbxprojPath appendingPrefix:fileNameAppendingPrefix];
    
    [self changeXcassetsFilesForDirectory:xcassetsFilesDirectory];
    NSLog(@"修改xxx.xcassets文件夹中的图片名完成");
    
    [self addGarbageCodeInEachMFileForDirectory:ChangeFileNameDirectory garbageCodePath:garbageCodePath instanceMethonPrefix:garbageCodeInstanceMethonPrefix];
    
    [self addGarbageFilesInDirectory:ChangeFileNameDirectory fileCounts:garbageFileCounts fileName:garbageFileName garbageCodePath:garbageCodePath instanceMethonPrefix:garbageCodeInstanceMethonPrefix];
    
    NSLog(@"god bless you!");
    
}

@end

