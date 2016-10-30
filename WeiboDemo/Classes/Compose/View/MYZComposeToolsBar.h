//
//  MYZComposeToolsBar.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ComposeToolsBarButtonType)
{
    ComposeToolsBarButtonTypePicture = 7, //图片
    ComposeToolsBarButtonTypeMention, //@
    ComposeToolsBarButtonTypeTrend, // 话题
    ComposeToolsBarButtonTypeEmotion // 表情
};

@class MYZComposeToolsBar;

@protocol MYZComposeToolsBarDelegate <NSObject>

@optional
- (void)composeToolsBar:(MYZComposeToolsBar *)bar didClickedButton:(ComposeToolsBarButtonType)btnType;

@end



@interface MYZComposeToolsBar : UIView

@property (nonatomic, assign, getter=isShowEmotionButton) BOOL showEmotionButton;

@property (nonatomic, assign) id<MYZComposeToolsBarDelegate> delegate;

@end
