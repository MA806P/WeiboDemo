//
//  MYZEmotionToolBar.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/31.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MYZEmotionToolBarButtonType)
{
    MYZEmotionToolBarButtonTypeRecent, //最近
    MYZEmotionToolBarButtonTypeDefault, //默认
    MYZEmotionToolBarButtonTypeEmoji, //Emoji
    MYZEmotionToolBarButtonTypeLang //浪小花
};


@interface MYZEmotionToolBar : UIView

@end
