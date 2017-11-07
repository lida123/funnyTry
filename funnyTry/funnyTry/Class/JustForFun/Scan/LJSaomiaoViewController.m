//
//  LJSaomiaoViewController.m
//  nurse
//
//  Created by LJ_Gaoqiang on 16/1/7.
//  Copyright © 2016年 LJ_Gaoqiang. All rights reserved.
//

#import "LJSaomiaoViewController.h"
#import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>

@interface LJSaomiaoViewController ()<AVCaptureMetadataOutputObjectsDelegate> {
    NSTimer * _timer;
    BOOL _goUp;
    NSInteger _num;
    UIImageView * _line;
}
@property (strong, nonatomic) AVCaptureDevice *device;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation LJSaomiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码";
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setUpUI];
}

- (void)setUpUI{
    /* 取消按钮 */
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton.frame = CGRectMake((self.view.bounds.size.width - 120)/2, 420, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    /* 说明文字 */
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 290)/2, 40, 290, 50)];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.numberOfLines = 1;
    promptLabel.textColor = [UIColor whiteColor];
    promptLabel.text = @"将二维码/条码放入框内,即可自动扫描";
    [self.view addSubview:promptLabel];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 300)/2, 100, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-220)/2, 110, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

- (void)animation {
    if (_goUp == 0) {
        _num ++;
        _line.frame = CGRectMake((self.view.bounds.size.width-220)/2, 110+2*_num, 220, 2);
        if (2*_num >= 280) {
            _goUp = YES;
        }
    }else {
        _num --;
        _line.frame = CGRectMake((self.view.bounds.size.width-220)/2, 110+2*_num, 220, 2);
        if (_num <= 0) {
            _goUp = NO;
        }
    }
}

#pragma mark - back
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:^{
        [_timer invalidate];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupCamera];
    [super viewWillAppear:animated];
    
}
- (void)setupCamera {
    // 1.创建捕捉会话
    _session = [[AVCaptureSession alloc] init];
    
    // 2.设置输入设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (error) {
        FTDPRINT(@"%@",error.localizedDescription);
        [self dismissViewControllerAnimated:YES completion:^{
            [SVProgressHUD showErrorWithStatus:@"无法打开相机,请在设置->隐私->相机中打开程序的相机使用权限"];
        }];
        return;
    }
    if ([_session canAddInput:self.input]) {
        [_session addInput:self.input];
    }
    
    // 3.设置输入方式
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([_session canAddOutput:self.output]) {
        [_session addOutput:self.output];
    }
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
 
    // 4.添加一个显示的layer
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake((self.view.bounds.size.width-280)/2,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // 5.开始扫描
    [_session startRunning];
}

#pragma mark -AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] >0) {
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
         [_timer invalidate];
         if (self.resultBlock) {
             self.resultBlock(stringValue);
         }
     }];
}

@end
