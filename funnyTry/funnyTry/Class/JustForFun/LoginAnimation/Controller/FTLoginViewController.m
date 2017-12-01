//
//  FTLoginViewController.m
//  funnyTry
//
//  Created by SGQ on 2017/11/30.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTLoginViewController.h"
#import "LYButton.h"
#import "LYTextField.h"
#import <AVFoundation/AVFoundation.h>
#import "NextViewController.h"

@interface FTLoginViewController () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) NSUInteger a;
@property (nonatomic, assign) BOOL second;
@end

@implementation FTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.a = 1;
    self.navigationItem.title = @"Login";
    
    // 渐变背景
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(__bridge id)[UIColor purpleColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0.65,@1];
    [self.view.layer addSublayer:gradientLayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setUpView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

-(void)setUpView{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    titleLabel.center = CGPointMake(self.view.center.x, 150);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"CLOVER";
    titleLabel.font = [UIFont systemFontOfSize:40.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMusic)];
    [titleLabel addGestureRecognizer:tap];
    
    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    detail.center = CGPointMake(self.view.center.x,100);
    detail.textColor = [UIColor whiteColor];
    detail.text = @"Don`t have an account yet? Sign Up";
    detail.font = [UIFont systemFontOfSize:13.f];
    detail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:detail];
    
    LYTextField *username = [[LYTextField alloc]initWithFrame:CGRectMake(0, 0, 270, 30)];
    username.center = CGPointMake(self.view.center.x, 350);
    username.ly_placeholder = @"Username";
    username.tag = 0;
    [self.view addSubview:username];
    
    LYTextField *password = [[LYTextField alloc]initWithFrame:CGRectMake(0, 0, 270, 30)];
    password.center = CGPointMake(self.view.center.x, username.center.y+60);
    password.ly_placeholder = @"Password";
    password.tag = 1;
    [self.view addSubview:password];
    
    LYButton *login = [[LYButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    login.center = CGPointMake(self.view.center.x, password.center.y+100);
    [self.view addSubview:login];
    
    __block LYButton *button = login;
    
    login.translateBlock = ^{
        NSLog(@"跳转了哦");
        button.bounds = CGRectMake(0, 0, 44, 44);
        button.layer.cornerRadius = 22;
        NextViewController *nextVC = [[NextViewController alloc]init];
        [self.navigationController presentViewController:nextVC animated:YES completion:nil];
        
    };
}

- (void)playMusic {
    // 1.获取要播放音频文件的URL
    NSString *name = [NSString stringWithFormat:@"%zd",self.a];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"m4a"];;
    NSURL *fileURL =  [NSURL fileURLWithPath:path];
    // 2.创建 AVAudioPlayer 对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    self.audioPlayer.volume = 1;
    // 4.设置循环播放
    self.audioPlayer.delegate = self;
    // 5.开始播放
    [self.audioPlayer play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _a++;
    if (!self.second) {
        if (_a < 16) {
            [self playMusic];
        }else {
            self.second = YES;
            _a = 1;
            [self playMusic];
        }
    }else {
        if (_a < 13) {
            [self playMusic];
        }else {
            _a = 1;
            [self playMusic];
        }
    }
}

@end
