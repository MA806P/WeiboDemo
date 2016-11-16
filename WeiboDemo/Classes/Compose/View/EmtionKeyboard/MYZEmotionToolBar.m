//
//  MYZEmotionToolBar.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/31.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionToolBar.h"

@interface MYZEmotionToolBar ()

@property (nonatomic, weak) UIScrollView * btnContentScrollView;
@property (nonatomic, weak) UIButton * btnSelected;

@end

@implementation MYZEmotionToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.image = [UIImage myz_stretchImageWithName:@"compose_emotion_table_mid_normal"];
        
        UIScrollView * btnContentScrollView = [[UIScrollView alloc] init];
        btnContentScrollView.backgroundColor = [UIColor clearColor];
        btnContentScrollView.alwaysBounceHorizontal = YES;
        [self addSubview:btnContentScrollView];
        self.btnContentScrollView = btnContentScrollView;
        
        [self createButtonWithTitle:@"最近" type:MYZEmotionToolBarButtonTypeRecent];
        [self createButtonWithTitle:@"默认" type:MYZEmotionToolBarButtonTypeDefault];
        [self createButtonWithTitle:@"Emoji" type:MYZEmotionToolBarButtonTypeEmoji];
        [self createButtonWithTitle:@"浪小花" type:MYZEmotionToolBarButtonTypeLang];
        
    }
    return self;
}


- (void)createButtonWithTitle:(NSString *)title type:(MYZEmotionToolBarButtonType)type
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:MYZColor(190, 190, 190) forState:UIControlStateNormal];
    [btn setTitleColor:MYZColor(100, 100, 100) forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage myz_stretchImageWithName:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage myz_stretchImageWithName:@"compose_emotion_table_mid_selected"] forState:UIControlStateHighlighted];
    btn.tag = type;
    [btn addTarget:self action:@selector(toolBarBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnContentScrollView addSubview:btn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.btnContentScrollView.frame = self.bounds;
    self.btnContentScrollView.contentSize = self.frame.size;
    
    CGFloat btnW = self.frame.size.width / 4.0;
    CGFloat btnH = self.frame.size.height;
    
    UIButton * recentBtn = [self viewWithTag:MYZEmotionToolBarButtonTypeRecent];
    recentBtn.frame = CGRectMake(0, 0, btnW, btnH);
    UIButton * defaultBtn = [self viewWithTag:MYZEmotionToolBarButtonTypeDefault];
    defaultBtn.frame = CGRectMake(btnW, 0, btnW, btnH);
    UIButton * emojiBtn = [self viewWithTag:MYZEmotionToolBarButtonTypeEmoji];
    emojiBtn.frame = CGRectMake(btnW*2.0, 0, btnW, btnH);
    UIButton * langBtn = [self viewWithTag:MYZEmotionToolBarButtonTypeLang];
    langBtn.frame = CGRectMake(btnW*3.0, 0, btnW, btnH);
}

- (void)toolBarBtnTouch:(UIButton *)btn
{
    NSLog(@"--- %ld ", btn.tag);
    
    //判断是否点击同一个按钮
    if (btn.tag == self.btnSelected.tag) { return; }
    
    self.btnSelected.selected = NO;
    btn.selected = YES;
    self.btnSelected = btn;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolBarButtonClickWithType:)])
    {
        [self.delegate emotionToolBarButtonClickWithType:btn.tag];
    }
    
}

#pragma mark - 外部调用的方法

//当滑动到对应的表情时，切换选中的按钮
- (void)changeSelectButtonWithType:(MYZEmotionToolBarButtonType)btnType
{
    UIButton * btn = [self viewWithTag:btnType];
    
    self.btnSelected.selected = NO;
    btn.selected = YES;
    self.btnSelected = btn;
}


@end
