//
//  MYZTabBar.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZTabBar.h"


@interface MYZTabBar ()

@property (nonatomic, weak) UIButton * plusButton;

@end


@implementation MYZTabBar

#pragma mrak - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //self.backgroundImage = [UIImage imageNamed:@"tabbar_background"];
        self.selectionIndicatorImage = [UIImage imageNamed:@"navigationbar_button_background"];
        
        //添加加号按钮
        [self addPlusButton];
    }
    return self;
}


//添加tabbar中间的加号按钮
- (void)addPlusButton
{
    UIButton * plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    
    [plusButton addTarget:self action:@selector(plusButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusButton];
    self.plusButton = plusButton;
}

//加号按钮点击
- (void)plusButtonTouch
{
    if([self.tabBarDeleage respondsToSelector:@selector(tabBarPlusButtonTouch)])
    {
        [self.tabBarDeleage tabBarPlusButtonTouch];
    }
}

#pragma mark - 布局

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置加号按钮frame
    CGFloat plusW = self.plusButton.currentBackgroundImage.size.width;
    CGFloat plusH = self.plusButton.currentBackgroundImage.size.height;
    CGFloat plusX = (self.frame.size.width - plusW) * 0.5;
    CGFloat plusY = (self.frame.size.height - plusH) * 0.5;
    self.plusButton.frame = CGRectMake(plusX, plusY, plusW, plusH);
    
    //设置其他tabbarItem的frame
    NSInteger itemsCount = self.items.count;
    NSInteger divideIndex = itemsCount / 2; //超过中间加号的索引值,设置btn的frame时用到
    CGFloat tabBarBtnW = self.frame.size.width / (itemsCount + 1);
    CGFloat tabBarBtnH = self.frame.size.height;
    CGFloat tabBarBtnY = 0;
    NSInteger index = 0;
    for (UIView * tabBarButton in self.subviews)
    {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            CGFloat tabBarBtnX = 0.0;
            if (index >= divideIndex)
            {
                tabBarBtnX = tabBarBtnW * (index + 1);
            }
            else
            {
                tabBarBtnX = tabBarBtnW * index;
            }
            tabBarButton.frame = CGRectMake(tabBarBtnX, tabBarBtnY, tabBarBtnW, tabBarBtnH);
            
            index++;
        }
    }
    
}


@end
