//
//  MYZTabBarController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/25.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZTabBarController.h"
#import "MYZNavController.h"
#import "MYZTabBar.h"
#import "MYZHomeController.h"
#import "MYZProfileController.h"
#import "MYZComposeController.h"

@interface MYZTabBarController () <MYZTabBarDelegate>

@end


@implementation MYZTabBarController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tabbar
    MYZTabBar * tabBar = [[MYZTabBar alloc] init];
    tabBar.tabBarDeleage = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    //添加子控制器
    MYZHomeController * home = [[MYZHomeController alloc] init];
    [self addItemController:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    MYZProfileController * profile = [[MYZProfileController alloc] init];
    [self addItemController:profile title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

- (void)addItemController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    controller.title = title;
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIColor * titleNormalColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0];
    UIColor * titleSelectedColor = [UIColor colorWithRed:253/255.0 green:130/255.0 blue:36/255.0 alpha:1.0];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:titleNormalColor} forState:UIControlStateNormal];
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:titleSelectedColor} forState:UIControlStateSelected];
    
    MYZNavController * nav = [[MYZNavController alloc] initWithRootViewController:controller];
    
    [self addChildViewController:nav];
}

#pragma mark - BCTabBarDelegate

//点击加号按钮
- (void)tabBarPlusButtonTouch
{
    MYZComposeController * compose = [[MYZComposeController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
    
}


@end
