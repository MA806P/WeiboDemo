//
//  MYZTabBar.h
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYZTabBarDelegate <NSObject>

- (void)tabBarPlusButtonTouch;

@end


@interface MYZTabBar : UITabBar

@property (nonatomic, weak) id<MYZTabBarDelegate> tabBarDeleage;

@end
