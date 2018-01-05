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
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FTScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ScanQRCodeAction"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 100, 100, 25)];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    self.imageView.center = self.view.center;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.imageView addGestureRecognizer:tap];
    [self.view addSubview:self.imageView];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ScanQRCodeAction"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/* 给纯黑的二维码变色 */
- (void)tap {
    self.imageView.image =  [self imageBlackToTransparent:self.imageView.image withRed:arc4random_uniform(250) andGreen:arc4random_uniform(250) andBlue:arc4random_uniform(250)];
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
    self.imageView.hidden = YES;
    self.resultLabel.hidden = NO;
    self.resultLabel.text = result.length > 0 ? result : @"null";
    CGRect rect = [self.resultLabel.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.resultLabel.font} context:nil];
    self.resultLabel.frame = rect;
    self.resultLabel.center = self.view.center;
    [self.view addSubview:self.resultLabel];
    
    [[UIPasteboard generalPasteboard] setString:self.resultLabel.text];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.resultLabel.hidden = YES;
    
    [self.textField endEditing:YES];
    if (![self.textField hasText]) {
        self.imageView.hidden = YES;
        return;
    }
    self.imageView.userInteractionEnabled = YES;
    self.imageView.layer.shadowColor = [[UIColor clearColor] CGColor];
    self.imageView.hidden = NO;
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = self.textField.text;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5.显示二维码
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
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

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

#pragma mark - lazy initialize
-(UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.bounds) + 10, CGRectGetWidth(self.view.bounds), 0)];
        _resultLabel.textColor = [UIColor purpleColor];
        _resultLabel.font = [UIFont systemFontOfSize:18];
        _resultLabel.numberOfLines = 0;
    }
    return _resultLabel;
}
@end
