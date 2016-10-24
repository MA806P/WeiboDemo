//
//  MYZMenuPageController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/21.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZMenuPageController.h"
#import "MYZMenuView.h"

CGFloat const ActivityBarHeight = 64.0;
CGFloat const ActivityMenuHeight = 36.0;
//菜单栏最多一行宽排几个按钮
NSInteger const ActitvityMenuShowCount = 4;

@interface MYZMenuPageController ()

@end

@implementation MYZMenuPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //菜单栏
    MYZMenuView * menuView = [[MYZMenuView alloc] initWithFrame:CGRectMake(0, ActivityBarHeight, SCREEN_W, ActivityMenuHeight) titles:@[@"进行中",@"已结束",@"进行中",@"已结束",@"进行中",@"已结束",@"进行中",@"已结束"]];
    [self.view addSubview:menuView];
}



@end
