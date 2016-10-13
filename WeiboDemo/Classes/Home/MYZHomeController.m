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
#import "MYZUserInfo.h"
#import "MJRefresh.h"


#import "MYZDog.h"

@interface MYZHomeController ()

@property (nonatomic, strong) MYZUserInfo * userInfo;

@end

@implementation MYZHomeController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.account = [MYZTools account];
//    if (self.account == nil) { return; }
    
    //__weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    }];
    
}



#pragma mark - 网络请求


- (void)homeGetUserInfo
{
    
    
    
}









@end
