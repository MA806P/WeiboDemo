//
//  MYZComposeEmotionKeyboard.h
//  WeiboDemo
//
//  Created by MA806P on 2016/10/30.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZEmotion;

//typedef void(^EmotionKeyboardBlock)(MYZEmotion *);

@interface MYZComposeEmotionKeyboard : UIView

/** 表情键盘里的全部数据 */
@property (nonatomic, copy) NSArray * emotionKeyboardDataArray;

//改为发送通知
///** 选择表情回调 */
//@property (nonatomic, copy) EmotionKeyboardBlock emotionKeyboardBlock;

@end
