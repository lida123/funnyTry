//
//  FTPausePlayAnimationVC.m
//  funnyTry
//
//  Created by SGQ on 2017/12/14.
//  Copyright © 2017年 GQ. All rights reserved.
//

#import "FTPausePlayAnimationVC.h"
#import "IQiYIButton.h"
#import "YouKuPlayButton.h"

@interface FTPausePlayAnimationVC ()

@end

@implementation FTPausePlayAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"爱奇艺&优酷";
    
    //创建播放按钮，需要初始化一个状态，即显示暂停还是播放状态
    IQiYIButton *iQiYiButton = [[IQiYIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) playState:IQiYIButtonStatePause];
    iQiYiButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height/3);
    [iQiYiButton addTarget:self action:@selector(iQiYiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iQiYiButton];
    
    //创建播放按钮，需要初始化一个状态，即显示暂停还是播放状态
    YouKuPlayButton *youKuButton = [[YouKuPlayButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) playState:YouKuButtonStatePause];
    youKuButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height*2/3);
    [youKuButton addTarget:self action:@selector(yuKuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:youKuButton];

}

- (void)iQiYiButtonClick:(IQiYIButton*)button {
    if (button.playState == IQiYIButtonStatePause) {
        button.playState = IQiYIButtonStatePlay;
    }else if (button.playState == IQiYIButtonStatePlay) {
        button.playState = IQiYIButtonStatePause;
    }
}

- (void)yuKuButtonClick:(IQiYIButton*)button {
    if (button.playState == YouKuButtonStatePause) {
        button.playState = YouKuButtonStatePlay;
    }else if (button.playState == YouKuButtonStatePlay) {
        button.playState = YouKuButtonStatePause;
    }
}
@end
