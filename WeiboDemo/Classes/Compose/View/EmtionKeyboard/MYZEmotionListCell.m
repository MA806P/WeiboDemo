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

static NSInteger const EmotionIndexTag = 118;

@interface MYZEmotionListCell ()

@property (nonatomic, weak) UIView * emotionsContentView;


@end

@implementation MYZEmotionListCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor clearColor];//MYZRandomColor;
        self.backgroundColor = [UIColor clearColor];
        
        
        
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
        UIView * emotionsContentView = [[UIView alloc] init];
        [self.contentView addSubview:emotionsContentView];
        self.emotionsContentView = emotionsContentView;
        
        for (int i=0; i<20; i++)
        {
            MYZEmotionView * emotionView = [[MYZEmotionView alloc] init];
            emotionView.tag = EmotionIndexTag + i;
            [emotionView addTarget:self action:@selector(emotionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [emotionsContentView addSubview:emotionView];
        }
        
        //删除按钮
        UIButton * deleterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleterBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleterBtn addTarget:self action:@selector(deleteBtnTouch) forControlEvents:UIControlEventTouchUpInside];
        deleterBtn.tag = EmotionIndexTag + 20;
        [emotionsContentView addSubview:deleterBtn];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    CGFloat contentH = selfH - EmotionListSectionFooterH;
    
    self.emotionsContentView.frame = CGRectMake( 0, 0, selfW, contentH);
    CGFloat topMargin = 0;
    CGFloat bottomMargin = 0;
    CGFloat lrMargin = 0;
    
    NSInteger rows = 3;
    NSInteger columns = 7;
    
    CGFloat emotionW = (selfW - lrMargin*2)/(columns*1.0);
    CGFloat emotionH = (contentH - topMargin - bottomMargin)/(rows * 1.0);
    
    for (NSInteger i = 0; i<21; i++)
    {
        CGFloat emotionX = lrMargin + emotionW * (i % columns);
        CGFloat emotionY = topMargin + emotionH * (i/columns);
        
        NSInteger viewTag = i + EmotionIndexTag;
        UIView * subView = [self.emotionsContentView viewWithTag:viewTag];
        subView.frame = CGRectMake(emotionX, emotionY, emotionW, emotionH);
    }
    
    
    self.emotionEmptyLabel.frame = self.contentView.bounds;
    self.emotionRecentLabel.frame = CGRectMake( 0, contentH, selfW, EmotionListSectionFooterH);
}

- (void)setEmotionArray:(NSArray *)emotionArray
{
    _emotionArray = emotionArray;
    
    for (NSInteger i = EmotionIndexTag; i< EmotionIndexTag+20; i++)
    {
        MYZEmotionView * emotionView = [self.emotionsContentView viewWithTag:i];
        emotionView.hidden = YES;
    }
    
    for (NSInteger index = 0; index<emotionArray.count; index++)
    {
        MYZEmotion * emotion = emotionArray[index];
        
        NSInteger viewTag = index + EmotionIndexTag;
        MYZEmotionView * emotionView = [self.emotionsContentView viewWithTag:viewTag];
        emotionView.hidden = NO;
        emotionView.emotion = emotion;
    }
    
    
}


- (void)emotionBtnTouch:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(emotionListCellTouchWithEmotion:)])
    {
        NSInteger emotionIndex = btn.tag - EmotionIndexTag;
        if (emotionIndex < self.emotionArray.count)
        {
            [self.delegate emotionListCellTouchWithEmotion:[self.emotionArray objectAtIndex:emotionIndex]];
        }
    }
}


- (void)deleteBtnTouch
{
    MYZLog(@"deleteBtnTouch");
}


@end
