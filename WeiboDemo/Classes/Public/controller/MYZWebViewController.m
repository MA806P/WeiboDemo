//
//  MYZWebViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZWebViewController.h"
#import <WebKit/WebKit.h>

@interface MYZWebViewController () <WKNavigationDelegate>

@end

@implementation MYZWebViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL * url = [NSURL URLWithString:self.urlString];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    
    WKWebView * webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[[WKWebViewConfiguration alloc] init]];
    webView.allowsBackForwardNavigationGestures = YES;
    [webView loadRequest:request];
    
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    [SVProgressHUD show];
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    MYZLog(@" -- didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    MYZLog(@" -- didFinishNavigation");
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    MYZLog(@"-- %@", error);
    [MYZTools showAlertWithText:@"加载失败，稍后重试"];
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
