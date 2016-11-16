//
//  MYZEmotionListCell.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/11/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionListCell.h"
#import "MYZEmotion.h"
#import "MYZEmotionView.h"

@interface MYZEmotionListCell ()

@property (nonatomic, weak) UIView * emotionsContentView;

@end

@implementation MYZEmotionListCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = MYZRandomColor;//[UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIView * emotionsContentView = [[UIView alloc] init];
        [self.contentView addSubview:emotionsContentView];
        self.emotionsContentView = emotionsContentView;
        
        UILabel * emptyLabel = [[UILabel alloc] init];
        emptyLabel.textColor = [UIColor lightGrayColor];
        emptyLabel.font = [UIFont systemFontOfSize:15];
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.text = @"还没有最近使用的表情";
        emptyLabel.hidden = YES;
        [self.contentView addSubview:emptyLabel];
        self.emotionEmptyLabel = emptyLabel;
        
        UILabel * recentLabel = [[UILabel alloc] init];
        recentLabel.textColor = [UIColor lightGrayColor];
        recentLabel.font = [UIFont systemFontOfSize:13];
        recentLabel.textAlignment = NSTextAlignmentCenter;
        recentLabel.text = @"最近使用的表情";
        recentLabel.hidden = YES;
        [self.contentView addSubview:recentLabel];
        self.emotionRecentLabel = recentLabel;
        
        
        //单个表情视图，每页最多显示20个
        for (int i=0; i<20; i++)
        {
            MYZEmotionView * emotionView = [[MYZEmotionView alloc] init];
            [self.contentView addSubview:emotionView];
        }
        
        //删除按钮
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.emotionsContentView.frame = self.contentView.bounds;
    self.emotionEmptyLabel.frame = self.contentView.bounds;
    self.emotionRecentLabel.frame = CGRectMake( 0, self.frame.size.height - EmotionListSectionFooterH, self.frame.size.width, EmotionListSectionFooterH);
}

- (void)setEmotionArray:(NSArray *)emotionArray
{
    _emotionArray = emotionArray;
    
    
}

@end
