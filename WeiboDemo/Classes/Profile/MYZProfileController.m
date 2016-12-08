//
//  MYZProfileController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZProfileController.h"
#import "MYZOAuthController.h"
#import "WeiboSDK.h"

@implementation MYZProfileController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
}

- (void)logout
{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray * subPaths = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString * subPath in subPaths)
    {
        NSString * fullSubpath = [cachPath stringByAppendingPathComponent:subPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullSubpath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:fullSubpath error:nil];
        }
    }
    
    MYZOAuthController * oauthVC = [[MYZOAuthController alloc] init];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:oauthVC];
    
}

@end
