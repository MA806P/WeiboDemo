//
//  MYZEmotionTool.h
//  WeiboDemo
//
//  Created by MA806P on 2016/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZEmotion;

@interface MYZEmotionTool : NSObject

/** 默认表情 */
+ (NSArray *)defaultEmotions;
/** emoji表情 */
+ (NSArray *)emojiEmotions;
/** 浪小花表情 */
+ (NSArray *)lxhEmotions;
/** 最近表情  */
+ (NSArray *)recentEmotions;

/** 根据表情的文字描述找出对应的表情对象 */
+ (MYZEmotion *)emotionWithDesc:(NSString *)desc;


@end
