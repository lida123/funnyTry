//
//  FTWebViewController.m
//  funnyTry
//
//  Created by SGQ on 2018/10/31.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTWebViewController.h"
#import "FTMyURLProtocol.h"

@interface FTWebViewController ()

@end

@implementation FTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[FTMyURLProtocol class]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}

@end
