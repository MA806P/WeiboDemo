//
//  MYZHomeController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#define TempFilepath [MYZFileRootPath stringByAppendingPathComponent:@"property.txt"]
#define TempFilepath2 [MYZFileRootPath stringByAppendingPathComponent:@"propertyDic.txt"]

#import "MYZHomeController.h"
#import "MYZAccount.h"

@implementation MYZHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MYZAccount * account = [MYZTools account];
    MYZLog(@"--- %@ ", account);
    
    NSDictionary * parameter = @{@"access_token":account.access_token, @"uid":account.uid};
    [MYZHttpTools get:@"https://api.weibo.com/2/users/show.json" parameters:parameter progress:nil success:^(id response) {
        
        NSDictionary * dic = (NSDictionary *)response;
        [dic writeToFile:TempFilepath2 atomically:YES];
        
    } failure:^(NSError *error) {
        MYZLog(@"--- %@", error);
    }];
    
}



@end
