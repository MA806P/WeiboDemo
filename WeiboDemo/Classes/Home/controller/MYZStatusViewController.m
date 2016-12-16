//
//  MYZStatusViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusViewController.h"
#import "MYZStatusTool.h"

@interface MYZStatusViewController ()

@end

@implementation MYZStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /**
    *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    *  id	true	int64	需要跳转的微博ID。
    */
    //这个接口只能查看授过权的用户微博其他人的微博看不到，"error":"Permission Denied!"
    NSDictionary * paramDict = @{@"access_token":[[MYZTools account] access_token], @"id":@(self.statusId.integerValue)};
    [MYZStatusTool getStatusDetailWithParam:paramDict success:^(id result) {
        NSLog(@" -- %@ ", result);
    } failure:^(NSError *error) {
        NSLog(@" -- %@ ", error);
    }];
    
}




@end
