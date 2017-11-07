//
//  LJSaomiaoViewController.m
//  nurse
//
//  Created by LJ_Gaoqiang on 16/1/7.
//  Copyright © 2016年 LJ_Gaoqiang. All rights reserved.
//

#import "LJSaomiaoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LJSaomiaoViewController ()<AVCaptureMetadataOutputObjectsDelegate> {
    NSTimer * _timer;
    BOOL _goUp;
    NSInteger _num;
    UIImageView * _line;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@end

@implementation LJSaomiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = [UIColor grayColor];
    // 取消按钮
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scanButton.frame = CGRectMake((self.view.bounds.size.width-120)/2, 420, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    // 说明文字
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-290)/2, 40, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-300)/2, 100, 300, 300)];
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
    }
    else {
        _num --;
        _line.frame = CGRectMake((self.view.bounds.size.width-220)/2, 110+2*_num, 220, 2);
        if (_num <= 0) {
            _goUp = NO;
        }
    }
}

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
    //device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //input
    NSError * error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        [self dismissViewControllerAnimated:YES completion:^{
            
            @"无法打开相机,请在设置->隐私->相机中打开程序的相机使用权限";
            
        }];
        return;
    }else {
        NSLog(@"ok");
    }
    //output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    //断点位置
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    //preview
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake((self.view.bounds.size.width-280)/2,110,280,280);
    //    _preview.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    // Start
    [_session startRunning];
    [self performSelector:@selector(failure) withObject:nil afterDelay:20.0];
}
- (void)failure {
    [self dismissViewControllerAnimated:YES completion:^{
        
        @"二维码可能不够清晰,请重新扫描";
        
        if (self.resultBlock) {
            self.resultBlock(nil);
        }
        
    }];
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects[0];
        stringValue = [self base64DecodeWithString:metadataObject.stringValue];
    }
    
    [_session stopRunning];
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         [_timer invalidate];
         if (self.resultBlock) {
             self.resultBlock(stringValue);
         }
     }];
}

- (NSString*)base64DecodeWithString:(NSString*)str{
    NSData * data = [[NSData alloc] initWithBase64EncodedString:str options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
