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
    MYZEmotionToolBarButtonTypeRecent = 5, //最近
    MYZEmotionToolBarButtonTypeDefault, //默认
    MYZEmotionToolBarButtonTypeEmoji, //Emoji
    MYZEmotionToolBarButtonTypeLang //浪小花
};

@protocol MYZEmotionToolBarDelegate <NSObject>

@optional
- (void)emotionToolBarButtonClickWithType:(MYZEmotionToolBarButtonType)btnType;

@end


@interface MYZEmotionToolBar : UIImageView

@property (nonatomic, assign) id <MYZEmotionToolBarDelegate> delegate;

- (void)changeSelectButtonWithType:(MYZEmotionToolBarButtonType)btnType;

@end
