//
//  MYZEmotionView.m
//  WeiboDemo
//
//  Created by MA806P on 2016/11/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionView.h"
#import "MYZEmotion.h"

@implementation MYZEmotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //self.backgroundColor = MYZRandomColor;
        self.backgroundColor = [UIColor clearColor];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setEmotion:(MYZEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.code) //emoji表情
    {
        // 设置emoji表情
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    }
    else //图片表情
    {
        NSString *icon = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
        UIImage *image = [UIImage imageNamed:icon];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
    
}

@end
