//
//  FTCodeConfuseTool.h
//  funnyTry
//
//  Created by SGQ on 2018/8/16.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTCodeConfuseTool : NSObject

/**
 * 如果项目里有.c文件(...)
 * 最好将项目中非三方代码放在一个文件夹.
 * 不修改category文件
 * 不修改xib文件
 * @param dir 文件目录
 * @param pbxprojPath xx.xcodeproj 显示包内容中的project.pbxproj的路径
 * @param appendingPrefix 在原本的文件名上追加的前缀
 */
+ (void)changeFileNameForDirectory:(NSString *)dir pbxprojPath:(NSString *)pbxprojPath appendingPrefix:(NSString *)appendingPrefix;

/**
 * 修改用Xcassets管理的图片内部名字
 */
+ (void)changeXcassetsFilesForDirectory:(NSString *)directory;


/**
 * 在该目录下的每一个.m文件中添加垃圾代码, 会自动更换实例方法名, 确保每个方法不同名
 * @param garbageCodePath 垃圾代码的文件. 只需要提供一个不报错的实例方法即可
 * @parpm instanceMethonPrefix 实例方法前缀.
 */
+ (void)addGarbageCodeInEachMFileForDirectory:(NSString*)directory garbageCodePath:(NSString*)garbageCodePath instanceMethonPrefix:(NSString*)instanceMethonPrefix;


/**
 * 在此目录下添加 count 个垃圾文件 fileName会自动更改
 */
+ (void)addGarbageFilesInDirectory:(NSString *)directory fileCounts:(NSInteger)count fileName:(NSString *)fileName garbageCodePath:(NSString*)garbageCodePath instanceMethonPrefix:(NSString*)instanceMethonPrefix;


//  对于 /* */  这种类型的注释, 如果在项目中存在不规范注释残留, 比如存在 /**/ /*  */ 会导致匹配超出预计目标
+ (void)deleteCommentForDirectory:(NSString *)directory;


// 命令行修改工程目录下所有 png 资源 hash 值
// 使用 ImageMagick 进行图片压缩，所以需要安装 ImageMagick，安装方法 brew install imagemagick
// cd  到指定目录
// find . -iname "*.png" -exec echo {} \; -exec convert {} {} \;
// or
// find . -iname "*.png" -exec echo {} \; -exec convert {} -quality 95 {} \;


/**
 * 综合
 * @param ChangeFileNameDirectory   需要改名的文件夹目录
 * @param pbxprojPath               xx.xcodeproj 显示包内容中的project.pbxproj的路径
 * @param fileNameAppendingPrefix   文件改名前缀
 * @param xcassetsFilesDirectory    Xcassets文件目录
 * @param garbageCodePath           提供一个实例方法的文件路径 方法以 xx_xx为名
 * @param garbageCodeInstanceMethonPrefix    需要改名的文件夹目录
 * @param garbageFileCounts         增加的垃圾文件数量
 * @param garbageFileName           垃圾文件名称(自动修改)
 */
+ (void)confuseProjectWithChangeFileNameDirectory:(NSString *)ChangeFileNameDirectory
                                      pbxprojPath:(NSString *)pbxprojPath
                          fileNameAppendingPrefix:(NSString *)fileNameAppendingPrefix xcassetsFilesDirectory:(NSString *)xcassetsFilesDirectory
                                  garbageCodePath:(NSString*)garbageCodePath
                             garbageCodeInstanceMethonPrefix:(NSString*)garbageCodeInstanceMethonPrefix
                                garbageFileCounts:(NSInteger)garbageFileCounts
                                  garbageFileName:(NSString *)garbageFileName;
@end








