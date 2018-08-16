//
//  FTChangeFileNameVC.m
//  funnyTry
//
//  Created by SGQ on 2018/4/18.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTChangeFileNameVC.h"

@interface FTChangeFileNameVC ()
@property (nonatomic, strong) NSMutableArray *allFiles;
@property (nonatomic, strong) NSMutableArray *allNewFiles;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *appendStr;
@end

@implementation FTChangeFileNameVC
#pragma mark -Life cycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _fileManager = [NSFileManager defaultManager];
        _allFiles = [NSMutableArray array];
        _allNewFiles = [NSMutableArray array];
        _filePath = @"/Users/wen/Desktop/needX/NOEETY/NOEETY/Classes";
        NSString *appendPath = [[NSBundle mainBundle] pathForResource:@"添加的代码的副本.txt" ofType:nil];
        _appendStr = [NSString stringWithContentsOfFile:appendPath encoding:NSUTF8StringEncoding error:nil];
    }
    return self;
}

static NSString *suffix = @"SUFFIX";
static NSString *moreFileName = @"TSRJCell";
static NSInteger moreFileCount = 1000;
static NSString *methodMark = @"mj_";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pickoutChangeableFileWithPath:self.filePath];

    [self changeFileName];

    [self changeFileText];

    [self addMoreFile];
    
    /*
     1.需要修改OpenedUDID的运行环境 文件 -fno-objc-arc
     2.CustomLineStyleItem可能会报错,直接删除
     3.[NSKeyedArchiver archiveRootObject..修改掉原来的path
     4.删除NSString+MD5文件
     5.地理位置授权增加key
     6.UITextfield+NumberLimit assign->retain
     7.删除Global目录下logoManager
     8.地理位置限制文件的替换
     */
    
//    [self changeFileNameContainLotteryWithPath:self.filePath];
}

#pragma mark - 修改带Lottery文件名
- (void)changeFileNameContainLotteryWithPath:(NSString *)path {
    NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:path];

    // 修改文件名
    NSInteger count = 0;
    for (NSString *fileName in fileEnumerator) {
        count++;
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSString *lastPath = [filePath lastPathComponent];
        
        if ([lastPath containsString:@"."]) {
            
            if ([lastPath containsString:@"Lottery"]){
                NSString *newLastPath = [lastPath stringByReplacingOccurrencesOfString:@"Lottery" withString:@"Sport"];
                NSString *newFilePath = [filePath stringByReplacingOccurrencesOfString:lastPath withString:newLastPath];
                [self.fileManager moveItemAtPath:filePath toPath:newFilePath error:NULL];
            } else if ([lastPath containsString:@"lottery"]) {
                NSString *newLastPath = [lastPath stringByReplacingOccurrencesOfString:@"lottery" withString:@"sport"];
                NSString *newFilePath = [filePath stringByReplacingOccurrencesOfString:lastPath withString:newLastPath];
                [self.fileManager moveItemAtPath:filePath toPath:newFilePath error:NULL];
            }
        }
    }
    FTDPRINT(@"%zd",count);
    
    // 修改文件中的Lottery
    fileEnumerator = [_fileManager enumeratorAtPath:path];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        NSString *lastPath = [filePath lastPathComponent];
        
        if ([lastPath containsString:@".m"] || [lastPath containsString:@".h"]) {
            
            NSError *error;
            NSString *fileOriginalString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"读文件出错");
            }
            
            NSArray *lines = [fileOriginalString componentsSeparatedByString:@"\n"];
            NSMutableString *newStringM = [NSMutableString string];
            for (NSString *line in lines) {
                NSString *newString = [self handleOriginalString:line];
                [newStringM appendString:newString];
                [newStringM appendString:@"\n"];
            }
            
            [[newStringM dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
        }
    }
}

// lottery更换为sport
static NSInteger changeCount = 0;
- (NSString *)handleOriginalString:(NSString *)oldString {
    if (!oldString) {
        return nil;
    }
    
    // 找出受保护的范围
    NSMutableString *newString = oldString.mutableCopy;
    NSString *regular = @"@\".*?lottery.*?\"";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:&error];
    NSMutableArray *protectRangeM = [NSMutableArray array];
    if (!error) {
        NSArray *matchs = [regex matchesInString:newString options:0 range:NSMakeRange(0, newString.length)];
        if (matchs.count > 0) {
            for (NSTextCheckingResult *match in matchs) {
                //                NSString *result = [newString substringWithRange:match.range];
                //                NSLog(@"%@",result);
                
                [protectRangeM addObject:[NSValue valueWithRange:match.range]];
            }
            
        } else {
            //            NSLog(@"正则没有匹配到数据");
        }
    } else {
        NSLog(@"正则表达式出错: %@", error);
    }
    
    // 找出所有范围
    NSString *regular2 = @"lottery";
    NSError *error2;
    NSRegularExpression *regex2= [NSRegularExpression regularExpressionWithPattern:regular2 options:NSRegularExpressionCaseInsensitive error:&error2];
    NSMutableArray *allRangeM = [NSMutableArray array];
    if (!error2) {
        NSArray *matchs = [regex2 matchesInString:newString options:0 range:NSMakeRange(0, newString.length)];
        if (matchs.count > 0) {
            for (NSTextCheckingResult *match in matchs) {
                //                NSString *result = [newString substringWithRange:match.range];
                //                NSLog(@"%@",result);
                
                [allRangeM addObject:[NSValue valueWithRange:match.range]];
            }
            
        } else {
            //            NSLog(@"正则没有匹配到数据");
        }
    } else {
        NSLog(@"error - %@", error);
    }
    //    NSLog(@"剔除前:%zd", allRangeM.count);
    for (NSValue *eachValue in [allRangeM copy]) {
        NSRange eachRange = eachValue.rangeValue;
        
        for (NSValue *protectValue in protectRangeM) {
            NSRange protectRange = protectValue.rangeValue;
            NSRange intersectionRange = NSIntersectionRange(protectRange, eachRange);
            if (NSEqualRanges(intersectionRange, eachRange)) {
                //                NSLog(@"这个是在字符串里面的lottery");
                [allRangeM removeObject:eachValue];
                break;
            }
        }
        
    }
    //    NSLog(@"剔除后:%zd", allRangeM.count);
    
    NSInteger delta = @"lottery".length - @"sport".length;
    for (NSInteger i = 0; i < allRangeM.count; i++) {
        NSRange range = [allRangeM[i] rangeValue];
        NSString *oriString = [oldString substringWithRange:range];
        if ([oriString containsString:@"Lottery"]) {
            [newString replaceCharactersInRange:NSMakeRange(range.location - delta * i, range.length) withString:@"Sport"];
        } else {
            [newString replaceCharactersInRange:NSMakeRange(range.location - delta * i, range.length) withString:@"sport"];
        }
        changeCount++;
        NSLog(@"进行第%zd了替换 %@", changeCount, oldString);
    
    }
    
    
    
    return newString;
}
#pragma mark -

#pragma mark -文件名混淆 增加垃圾代码 增加垃圾文件
- (void )pickoutChangeableFileWithPath:(NSString *)path
{
    NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:path];
    NSInteger count = 0;
    
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        
        if (filePath.lastPathComponent.length > 15 && ([filePath containsString:@".h"] || [filePath containsString:@".m"]) && ![filePath containsString:@"+"]){
            [self.allFiles addObject:filePath];
            count ++;
        }
    }
    
    NSLog(@"改名的文件共有 %zd",count);
}

- (void)changeFileName
{
    for (NSString *path in self.allFiles) {
        NSString *newPath = path.stringByDeletingPathExtension;
        newPath = [newPath stringByAppendingString:suffix];
        newPath = [NSString stringWithFormat:@"%@.%@",newPath,path.pathExtension];
        NSError *error;
        [self.fileManager moveItemAtPath:path toPath:newPath error:&error];
        if (error) {
            NSLog(@"ERROR1 = %@",error);
        } else {
            [self.allNewFiles addObject:newPath];
        }
    }
}

- (void)changeFileText
{
    NSMutableArray *allFiles = [NSMutableArray array];
    NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:self.filePath];
    for (NSString *fileName in fileEnumerator) {
        NSString *filePath = [self.filePath stringByAppendingPathComponent:fileName];
        
        if ([filePath containsString:@".h"] || [filePath containsString:@".m"]) {
            [allFiles addObject:filePath];
        }
    }
    
    // 便利所有文件
    NSInteger count = 0;
    NSInteger allCount = allFiles.count;
    NSLog(@"所有需要改内容的文件数量 %zd",allCount);
    
    for (NSString *path in allFiles) {
        @autoreleasepool {
            
            NSError *error;
            // 读出string
            NSMutableString *string = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
            BOOL isM = [path.pathExtension isEqualToString:@"m"];
            if (error) {
                NSLog(@"读文件出错 %@",error);
                continue;
            }
        
            NSMutableSet *set = [NSMutableSet set];
            for (NSString *filePath in self.allNewFiles) {
                
                NSString *fileName_SUFFIX = filePath.lastPathComponent.stringByDeletingPathExtension;
                NSString *fileName = [fileName_SUFFIX componentsSeparatedByString:suffix][0];
                
                // 防止同一个类名两次查询操作
                if ([set containsObject:fileName_SUFFIX]) {
                    continue;
                } else {
                    [set addObject:fileName_SUFFIX];
                }
                
                string = [self repleaceString:fileName_SUFFIX currentString:fileName string:string isM:isM];
            }
            
            // 添加代码
            if (isM) {
                NSRange endRange = [string rangeOfString:@"@end" options:NSBackwardsSearch range:NSMakeRange(0, string.length)];
                if (endRange.location != NSNotFound) {
                    
                    [string replaceCharactersInRange:endRange withString:[self appendStringAddCount]];
                }
            }
            
            
            NSError *insideError;
            [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&insideError];

            if (insideError) {
                NSLog(@"重写文件出错%@",insideError);
            }
        }
        
        NSLog(@"已经处理到 %zd/%zd",count,allCount);
        count++;
    }
    
    NSLog(@"end, god bless me!");
}

- (NSMutableString *)repleaceString:(NSString *)toReplaceString currentString:(NSString *)currentString string:(NSString*)string isM:(BOOL)isM
{
    NSMutableString *stringM = [NSMutableString stringWithString:string];
    
    // 拿到特殊字符的所有location
    NSMutableArray * arrayRanges = [NSMutableArray array];
    
    NSRange rang = [stringM rangeOfString:currentString options:0 range:NSMakeRange(0, string.length)]; //获取第一次出现的range
    if (rang.location != NSNotFound && rang.length != 0) {
        
        
        //添加符合条件的location进数组
        char nextString = [[stringM substringWithRange:NSMakeRange(rang.location + rang.length, 1)] characterAtIndex:0];
        char preString = [[stringM substringWithRange:NSMakeRange(rang.location - 1, 1)] characterAtIndex:0];
        // 0-9 A-Z  a-z
        BOOL next = (nextString >= 48 && nextString <= 57)||(nextString >= 65 && nextString <= 90) || (nextString >= 97 && nextString <= 122);
        BOOL pre = (preString >= 48 && preString <= 57) || (preString >= 65 && preString <= 90) || (preString >= 97 && preString <= 122);
        
        if ( !next  && !pre) {
            [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        }
        
        
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        
        for (int i = 0;; i++){
            if (0 == i){
                location = rang.location + rang.length;
                length = stringM.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }else{
                location = rang1.location + rang1.length;
                length = stringM.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            //在一个range范围内查找另一个字符串的range
            rang1 = [stringM rangeOfString:currentString options:0 range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0){
                break;
            }else {
                //添加符合条件的location进数组
                char nextString = [[stringM substringWithRange:NSMakeRange(rang1.location + rang1.length, 1)] characterAtIndex:0];
                char preString = [[stringM substringWithRange:NSMakeRange(rang1.location - 1, 1)] characterAtIndex:0];
                BOOL next = (nextString >= 48 && nextString <= 57) || (nextString >= 65 && nextString <= 90) || (nextString >= 97 && nextString <= 122);
                BOOL pre = (preString >= 48 && preString <= 57)|| (preString >= 65 && preString <= 90) || (preString >= 97 && preString <= 122);
                
                if ( !next  && !pre) {
                    [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
                }
            }
        }
    }
    
    NSInteger count = toReplaceString.length - currentString.length;
    for (NSInteger i = 0; i < arrayRanges.count; i++) {
        NSRange perRange = NSMakeRange([arrayRanges[i] integerValue], rang.length);
        [stringM insertString:suffix atIndex:perRange.location + perRange.length + count * i];
    }

    return stringM;
}

- (void)addMoreFile {
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *dirPath = [_filePath stringByAppendingPathComponent:@"More"];
    NSError *error;
    [mgr createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!error) {
        NSLog(@"创建目录成功");
    } else {
        NSLog(@"创建目录失败");
        return;
    }
    
    NSString *lastFileName = nil;
    for (NSInteger i = 0; i < moreFileCount; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%@%zd",moreFileName,i];
        [self createOneFileWithFileName:fileName atdirPath:dirPath mgr:mgr lastFileName:lastFileName];
        NSLog(@"%@",fileName);
        lastFileName = fileName;
    }

}

/*
 #import <Foundation/Foundation.h>
 
 @interface MoreViewTest : NSObject
 
 @end

 
 
 #import "MoreViewTest.h"
 
 @implementation MoreViewTest
 
 */
- (void)createOneFileWithFileName:(NSString *)fileName atdirPath:(NSString *)dirPath mgr:(NSFileManager *)mgr lastFileName:(NSString *)lastFileName {
    NSString *hString = [NSString stringWithFormat:@"#import <Foundation/Foundation.h> \n@interface %@ : NSObject \n@end",fileName];
    NSString *hPath = [NSString stringWithFormat:@"%@/%@.h",dirPath,fileName];
    [mgr createFileAtPath:hPath contents:[hString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    NSString *mString = nil;
    NSString *appendString = [self appendStringForClass:fileName];
    if (!lastFileName) {
        mString = [NSString stringWithFormat:@"#import \"%@.h\" \n@implementation %@ \n %@",fileName,fileName,appendString];
    } else {
        mString = [NSString stringWithFormat:@"#import \"%@.h\" \n#import \"%@.h\"  \n@implementation %@ \n %@",fileName,lastFileName,fileName,appendString];
    }
    NSString *mPath = [NSString stringWithFormat:@"%@/%@.m",dirPath,fileName];
    [mgr createFileAtPath:mPath contents:[mString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
}


- (NSString *)appendStringForClass:(NSString *)className {
    NSString *string = [_appendStr stringByReplacingOccurrencesOfString:methodMark withString:className];
    return string;
}

NSInteger count = 1;
- (NSString *)appendStringAddCount {
    NSString *countString = [NSString stringWithFormat:@"noee_%zd",count];
    NSString *string = [_appendStr stringByReplacingOccurrencesOfString:methodMark withString:countString];
    count++;
    return string;
}




@end
