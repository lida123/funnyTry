//
//  FTWKViewController.m
//  funnyTry
//
//  Created by SGQ on 2018/11/2.
//  Copyright © 2018年 GQ. All rights reserved.
//

#import "FTWKViewController.h"
#import <WebKit/WebKit.h>
#import "FTMyURLProtocol.h"
#import "NSURLProtocol+WKWebVIew.h"

@interface FTWKViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation FTWKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLProtocol registerClass:[FTMyURLProtocol class]];
    [FTMyURLProtocol registerForWKWebView];
    [self.view addSubview:self.webView];
}


- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 30.0;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if ([_webView respondsToSelector:@selector(setNavigationDelegate:)]) {
            [_webView setNavigationDelegate:self];
        }
        
        if ([_webView respondsToSelector:@selector(setDelegate:)]) {
            [_webView setUIDelegate:self];
        }
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        
    }
    return _webView;
}
@end
