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
#import "MYZEmotionPreview.h"

static NSInteger const EmotionIndexTag = 118;

@interface MYZEmotionListCell ()

@property (nonatomic, weak) UIView * emotionsContentView;

@property (nonatomic, strong) MYZEmotionPreview * emotionPreview;

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
        
        //添加长按手势，长按弹框显示表情
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(emotionsContentViewLongPressAction:)];
        [emotionsContentView addGestureRecognizer:longPress];
        
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
    CGFloat lrMargin = 10;
    
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

- (MYZEmotionPreview *)emotionPreview
{
    if (_emotionPreview == nil)
    {
        _emotionPreview = [[MYZEmotionPreview alloc] init];
    }
    return _emotionPreview;
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

//表情选择处理事件
- (void)selectedEmotion:(MYZEmotion *)emotion
{
    if ([self.delegate respondsToSelector:@selector(emotionListCellTouchWithEmotion:)])
    {
        [self.delegate emotionListCellTouchWithEmotion:emotion];
    }
}

//表情按钮点击
- (void)emotionBtnTouch:(UIButton *)btn
{
    NSInteger emotionIndex = btn.tag - EmotionIndexTag;
    if (emotionIndex < self.emotionArray.count)
    {
        [self selectedEmotion:[self.emotionArray objectAtIndex:emotionIndex]];
    }
}

//删除按钮点击
- (void)deleteBtnTouch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ComposeEmotionKeyboardDeleteKey object:nil];
}

//长按手势处理，长按手势触发之后不松，滑动也会调用此方法
- (void)emotionsContentViewLongPressAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //触摸点
    CGPoint pressPoint = [gestureRecognizer locationInView:self.emotionsContentView];
    //MYZLog(@"long press --- %@ ", NSStringFromCGPoint(pressPoint));
    
    //寻找触摸点所在的emotionView
    MYZEmotionView * emotionView;
    for(MYZEmotionView * obj in self.emotionsContentView.subviews)
    {
        if (CGRectContainsPoint(obj.frame, pressPoint) && [obj isKindOfClass:[MYZEmotionView class]] && obj.hidden == NO)
        {
            emotionView = obj;
            break;
        }
    }
    
    if (emotionView == nil)
    {
        [self.emotionPreview dismiss];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //手松开
        //MYZLog(@" --- ended %@ ", emotionView.emotion);
        [self.emotionPreview dismiss];
        
        //选择表情处理
        [self selectedEmotion:emotionView.emotion];
    }
    else
    {
        //手没松，或者在滑动
        //MYZLog(@" --- %@ ", emotionView.emotion);
        [self.emotionPreview showFromEmotionView:emotionView];
    }
    
}

@end
