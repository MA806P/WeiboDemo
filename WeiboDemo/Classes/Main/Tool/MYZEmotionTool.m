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

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions)
    {
        //默认表情
        NSString * defaultPlist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        NSArray * defaultEmotionInfos = [NSArray arrayWithContentsOfFile:defaultPlist];
        NSMutableArray * defaultEmotionArray = [NSMutableArray array];
        for (NSDictionary * tempDic in defaultEmotionInfos)
        {
            MYZEmotion * emotion = [[MYZEmotion alloc] initEmotionWithDictionary:tempDic];
            emotion.directory = @"EmotionIcons/default";
            [defaultEmotionArray addObject:emotion];
        }
        _defaultEmotions = [NSArray arrayWithArray:defaultEmotionArray];
        
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions)
    {
        //emoji表情
        NSString * emojiPlist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        NSArray * emojiInfos = [NSArray arrayWithContentsOfFile:emojiPlist];
        NSMutableArray * emojiArray = [NSMutableArray array];
        
        [emojiInfos enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MYZEmotion * emotion = [[MYZEmotion alloc] initEmotionWithDictionary:obj];
            emotion.directory = @"EmotionIcons/emoji";
            [emojiArray addObject:emotion];
        }];
        _emojiEmotions = [NSArray arrayWithArray:emojiArray];
    }
    return _emojiEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions)
    {
        //小浪花表情
        NSString * lxhPlist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        NSArray * lxhInfos = [NSArray arrayWithContentsOfFile:lxhPlist];
        NSMutableArray * lxhArray = [NSMutableArray array];
        
        [lxhInfos enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MYZEmotion * emotion = [[MYZEmotion alloc] initEmotionWithDictionary:obj];
            emotion.directory = @"EmotionIcons/lxh";
            [lxhArray addObject:emotion];
        }];
        _lxhEmotions = [NSArray arrayWithArray:lxhArray];
    }
    return _lxhEmotions;
}


+ (MYZEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return nil;
    
    __block MYZEmotion *foundEmotion = nil;
    
    // 从默认表情中找
    [[self defaultEmotions] enumerateObjectsUsingBlock:^(MYZEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(MYZEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]) {
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}


@end
