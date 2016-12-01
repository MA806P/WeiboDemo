//
//  MYZEmotionAttachment.m
//  WeiboDemo
//
//  Created by MA806P on 2016/12/1.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionAttachment.h"
#import "MYZEmotion.h"

@implementation MYZEmotionAttachment

- (void)setEmotion:(MYZEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",emotion.directory, emotion.png]];
}

@end
