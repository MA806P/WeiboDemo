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
    
}


- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    MYZLog(@" -- didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    MYZLog(@" -- didFinishNavigation");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    MYZLog(@"-- %@", error);
}


@end
