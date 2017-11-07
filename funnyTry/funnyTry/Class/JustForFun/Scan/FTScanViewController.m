//
//  FTScanViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/7.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTScanViewController.h"
#import "LJSaomiaoViewController.h"

@interface FTScanViewController ()
@property (nonatomic, strong) UILabel *resultLabel;
@end

@implementation FTScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
}

#pragma mark - rightItemAction
- (void)rightItemClick:(UIBarButtonItem *)item {
    LJSaomiaoViewController *scanVC = [[LJSaomiaoViewController alloc] init];
    WS(weakSelf)
    [scanVC setResultBlock:^(NSString *result) {
        [weakSelf showResult:result];
    }];
    [self.navigationController presentViewController:scanVC animated:YES completion:nil];
}

- (void)showResult:(NSString *)result {
    self.resultLabel.text = result.length > 0 ? result : @"null";
    CGRect rect = [self.resultLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.resultLabel.font} context:nil];
    self.resultLabel.frame = rect;
    self.resultLabel.center = self.view.center;
    [self.view addSubview:self.resultLabel];
}

#pragma mark - lazy initialize
-(UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0)];
        _resultLabel.textColor = [UIColor purpleColor];
        _resultLabel.font = [UIFont systemFontOfSize:18];
        _resultLabel.numberOfLines = 0;
    }
    return _resultLabel;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = @"http://www.520it.com";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.显示二维码
   // self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
