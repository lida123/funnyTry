//
//  FTPackImageViewController.m
//  funnyTry
//
//  Created by SGQ on 2018/7/25.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTPackImageViewController.h"

@interface FTPackImageViewController ()

@end

@implementation FTPackImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLauchImage];
    [self createLogo];
    FTDPRINT(@"搞定");
}

- (void)createLauchImage {
    UIImage *originImage = [UIImage imageNamed:@"xunwei_launch"];
    NSString *dirPath = @"/Users/wen/Desktop/needX/launch";
    NSDictionary *sizes = @{@"1.png":[NSValue valueWithCGSize:CGSizeMake(320, 480)],
                            @"2.png":[NSValue valueWithCGSize:CGSizeMake(640, 960)],
                            @"3.png":[NSValue valueWithCGSize:CGSizeMake(640, 1136)],
                            @"4.png":[NSValue valueWithCGSize:CGSizeMake(640, 960)],
                            @"5.png":[NSValue valueWithCGSize:CGSizeMake(640, 1136)],
                            @"6.png":[NSValue valueWithCGSize:CGSizeMake(1242, 2208)],
                            @"7.png":[NSValue valueWithCGSize:CGSizeMake(750, 1334)],
                            @"8.png":[NSValue valueWithCGSize:CGSizeMake(750, 1334)],
                            @"9.png":[NSValue valueWithCGSize:CGSizeMake(1125, 2436)],
                            };
    for (NSString *key in sizes.allKeys) {
        CGSize size = [sizes[key] CGSizeValue];
        UIImage *image = [self createOneImageWithSize:size image:originImage];
        NSString *path = [dirPath stringByAppendingPathComponent:key];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:path atomically:YES];
    }

}

- (void)createLogo {
    UIImage *originImage = [UIImage imageNamed:@"xunwei_logo"];
    NSString *dirPath = @"/Users/wen/Desktop/needX/logo";
    NSDictionary *sizes = @{@"noti2x.png":[NSValue valueWithCGSize:CGSizeMake(40, 40)],
                            @"noti3x.png":[NSValue valueWithCGSize:CGSizeMake(60, 60)],
                            @"spot56set5111x.png":[NSValue valueWithCGSize:CGSizeMake(29, 29)],
                            @"spot56set5112x.png":[NSValue valueWithCGSize:CGSizeMake(58, 58)],
                            @"spot56set5113x.png":[NSValue valueWithCGSize:CGSizeMake(87, 87)],
                            @"spot7112x.png":[NSValue valueWithCGSize:CGSizeMake(80, 80)],
                            @"spot7113x.png":[NSValue valueWithCGSize:CGSizeMake(120, 120)],
                            @"iphoneapp561x.png":[NSValue valueWithCGSize:CGSizeMake(57, 57)],
                            @"iphoneapp562x.png":[NSValue valueWithCGSize:CGSizeMake(114, 114)],
                            @"iphoneapp7112x.png":[NSValue valueWithCGSize:CGSizeMake(120, 120)],
                            @"iphoneapp7113x.png":[NSValue valueWithCGSize:CGSizeMake(180, 180)],
                            @"appstore1024.png":[NSValue valueWithCGSize:CGSizeMake(1024, 1024)],
                            };
    for (NSString *key in sizes.allKeys) {
        CGSize size = [sizes[key] CGSizeValue];
        UIImage *image = [self createOneImageWithSize:size image:originImage];
        NSString *path = [dirPath stringByAppendingPathComponent:key];
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:path atomically:YES];
    }
    
}

- (UIImage *)createOneImageWithSize:(CGSize)size image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
