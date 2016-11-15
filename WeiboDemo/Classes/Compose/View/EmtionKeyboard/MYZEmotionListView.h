//
//  MYZEmotionListView.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/31.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYZEmotionToolBar.h"

FOUNDATION_EXPORT CGFloat const ComposeEmotionKeyboardH; //表情键盘高度
FOUNDATION_EXPORT CGFloat const ComposeEmotionToolBarH; //表情键盘底部的选择表情的按钮

@protocol MYZEmotionListViewDelegate <NSObject>

@optional
- (void)emotionListScrollToType:(MYZEmotionToolBarButtonType)type;

@end


@interface MYZEmotionListView : UIView

/** 表情键盘里的全部数据 */
@property (nonatomic, copy) NSArray * emotionDataArray;

@property (nonatomic, assign) id <MYZEmotionListViewDelegate> delegate;

/** 点击底部按钮选择显示不同的表情列表 */
- (void)emotionListViewShowWithType:(MYZEmotionToolBarButtonType)type;

@end
