//
//  MYZNavController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/25.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZNavController.h"

@implementation MYZNavController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}


@end
