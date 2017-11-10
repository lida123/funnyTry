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
#import "FTScanBackgroundView.h"

@interface LJSaomiaoViewController ()<AVCaptureMetadataOutputObjectsDelegate> {
    NSTimer * _timer;
    BOOL _goUp;
    NSInteger _num;
    UIImageView * _line;
    FTScanBackgroundView *_bgView;
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setUpUI];
}

- (void)setUpUI{
    CGFloat bgW = CGRectGetWidth(self.view.bounds) * 0.6875;
    CGFloat bgH = bgW;
    _bgView = [[FTScanBackgroundView alloc] initWithFrame:CGRectMake(0, 0, bgW, bgH)];
    _bgView.center = self.view.center;
    [self.view addSubview:_bgView];
    
    /* 取消按钮 */
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    [scanButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(_bgView.center.x - 60, CGRectGetMaxY(_bgView.frame) + 20, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    /* 说明文字 */
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.numberOfLines = 1;
    promptLabel.textColor = [UIColor purpleColor];
    promptLabel.text = @"将二维码/条码放入框内,即可自动扫描";
    [promptLabel sizeToFit];
    promptLabel.center = CGPointMake(_bgView.center.x, CGRectGetMinY(_bgView.frame) - 50);
    [self.view addSubview:promptLabel];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_bgView.frame), CGRectGetWidth(self.view.frame),12)];
    _line.image = [UIImage imageNamed:@"ff_QRCodeScanLine"];
    [self.view addSubview:_line];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

- (void)animation {
    if (!_goUp) {
        _num ++;
        _line.frame = CGRectMake(CGRectGetMinX(_bgView.frame), CGRectGetMinY(_bgView.frame) + 2 *_num, CGRectGetWidth(_bgView.frame),6);
        if (2*_num >= CGRectGetHeight(_bgView.frame) - 6) {
            _goUp = YES;
        }
    }else {
        _num --;
        _line.frame = CGRectMake(CGRectGetMinX(_bgView.frame), CGRectGetMinY(_bgView.frame) + 2 *_num, CGRectGetWidth(_bgView.frame),6);
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
    _preview.frame = self.view.bounds;
    [self addBackgroundLayer];
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // 5.开始扫描
    [_session startRunning];
}

- (void)addBackgroundLayer {
    CGFloat h1 = _bgView.frame.size.height - FTNavigationBarHeight;
    CGFloat x = _bgView.frame.origin.x;
    CGFloat opacity = 0.3;
    
    CALayer *backgroundLayer1 = [CALayer layer];
    backgroundLayer1.frame = CGRectMake(0, 0, self.view.bounds.size.width, h1);
    backgroundLayer1.backgroundColor = [UIColor blackColor].CGColor;
    backgroundLayer1.opacity = opacity;
    [_preview addSublayer:backgroundLayer1];
    
    CALayer *backgroundLayer2 = [CALayer layer];
    backgroundLayer2.frame = CGRectMake(0, h1, x,_preview.bounds.size.height - h1);
    backgroundLayer2.backgroundColor = [UIColor blackColor].CGColor;
    backgroundLayer2.opacity = opacity;
    [_preview addSublayer:backgroundLayer2];
    
    CALayer *backgroundLayer3 = [CALayer layer];
    backgroundLayer3.frame = CGRectMake(x + CGRectGetWidth(_bgView.bounds), h1, x,_preview.bounds.size.height - h1);
    backgroundLayer3.backgroundColor = [UIColor blackColor].CGColor;
    backgroundLayer3.opacity = opacity;
    [_preview addSublayer:backgroundLayer3];
    
    CALayer *backgroundLayer4 = [CALayer layer];
    backgroundLayer4.frame = CGRectMake(x,CGRectGetMaxY(_bgView.frame), _bgView.bounds.size.width,_preview.bounds.size.height - h1 - _bgView.frame.size.height + 1);
    backgroundLayer4.backgroundColor = [UIColor blackColor].CGColor;
    backgroundLayer4.opacity = opacity;
    [_preview addSublayer:backgroundLayer4];
    
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
