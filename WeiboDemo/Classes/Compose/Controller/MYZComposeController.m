//
//  MYZComposeController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZComposeController.h"
#import "MYZComposeTextView.h"

@implementation MYZComposeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendStatus)];
    
    MYZComposeTextView * textView = [[MYZComposeTextView alloc] initWithFrame:self.view.bounds];
    textView.placeholder = @"分享新鲜事...";
    [self.view addSubview:textView];
    
}



- (void)sendStatus
{
}


- (void)cancelBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
