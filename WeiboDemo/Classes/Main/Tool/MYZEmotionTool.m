//
//  MYZEmotionTool.m
//  WeiboDemo
//
//  Created by MA806P on 2016/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionTool.h"
#import "MYZEmotion.h"

@implementation MYZEmotionTool

/** 默认表情 */
static NSArray *_defaultEmotions;
/** emoji表情 */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;

/** 最近表情 */
static NSMutableArray *_recentEmotions;

//+ (NSArray *)defaultEmotions
//{
//    if (!_defaultEmotions) {
//        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
//        _defaultEmotions = [MYZEmotion objectArrayWithFile:plist];
//        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
//    }
//    return _defaultEmotions;
//}
//
//+ (NSArray *)emojiEmotions
//{
//    if (!_emojiEmotions) {
//        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
//        _emojiEmotions = [HMEmotion objectArrayWithFile:plist];
//        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/emoji"];
//    }
//    return _emojiEmotions;
//}
//
//+ (NSArray *)lxhEmotions
//{
//    if (!_lxhEmotions) {
//        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
//        _lxhEmotions = [HMEmotion objectArrayWithFile:plist];
//        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];
//    }
//    return _lxhEmotions;
//}
//
//+ (NSArray *)recentEmotions
//{
//    if (!_recentEmotions) {
//        // 去沙盒中加载最近使用的表情数据
//        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:HMRecentFilepath];
//        if (!_recentEmotions) { // 沙盒中没有任何数据
//            _recentEmotions = [NSMutableArray array];
//        }
//    }
//    return _recentEmotions;
//}
//
//// Emotion -- 戴口罩 -- Emoji的plist里面加载的表情
//+ (void)addRecentEmotion:(HMEmotion *)emotion
//{
//    // 加载最近的表情数据
//    [self recentEmotions];
//    
//    // 删除之前的表情
//    [_recentEmotions removeObject:emotion];
//    
//    // 添加最新的表情
//    [_recentEmotions insertObject:emotion atIndex:0];
//    
//    // 存储到沙盒中
//    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:HMRecentFilepath];
//}
//
//+ (HMEmotion *)emotionWithDesc:(NSString *)desc
//{
//    if (!desc) return nil;
//    
//    __block HMEmotion *foundEmotion = nil;
//    
//    // 从默认表情中找
//    [[self defaultEmotions] enumerateObjectsUsingBlock:^(HMEmotion *emotion, NSUInteger idx, BOOL *stop) {
//        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
//            foundEmotion = emotion;
//            *stop = YES;
//        }
//    }];
//    if (foundEmotion) return foundEmotion;
//    
//    // 从浪小花表情中查找
//    [[self lxhEmotions] enumerateObjectsUsingBlock:^(HMEmotion *emotion, NSUInteger idx, BOOL *stop) {
//        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
//            foundEmotion = emotion;
//            *stop = YES;
//        }
//    }];
//    
//    return foundEmotion;
//}


@end
