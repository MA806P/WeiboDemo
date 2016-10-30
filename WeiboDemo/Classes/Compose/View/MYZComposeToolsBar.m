//
//  MYZComposeToolsBar.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZComposeToolsBar.h"

@interface MYZComposeToolsBar ()

//弹出表情键盘按钮
@property (nonatomic, weak) UIButton * emotionButton;

@end

@implementation MYZComposeToolsBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        //图片 @ 话题 表情
        [self addToolsBarBtnWithImageName:@"compose_toolbar_picture" highlightImageName:@"compose_toolbar_picture_highlighted" type:ComposeToolsBarButtonTypePicture];
        [self addToolsBarBtnWithImageName:@"compose_mentionbutton_background" highlightImageName:@"compose_mentionbutton_background_highlighted" type:ComposeToolsBarButtonTypeMention];
        [self addToolsBarBtnWithImageName:@"compose_trendbutton_background" highlightImageName:@"compose_trendbutton_background_highlighted" type:ComposeToolsBarButtonTypeTrend];
        [self addToolsBarBtnWithImageName:@"compose_emoticonbutton_background" highlightImageName:@"compose_emoticonbutton_background_highlighted" type:ComposeToolsBarButtonTypeEmotion];
        
    }
    return self;
}


- (void)addToolsBarBtnWithImageName:(NSString *)name highlightImageName:(NSString *)hName type:(ComposeToolsBarButtonType)btnType
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hName] forState:UIControlStateHighlighted];
    btn.tag = btnType;
    [btn addTarget:self action:@selector(toolsBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    if (btnType == ComposeToolsBarButtonTypeEmotion)
    {
        self.emotionButton = btn;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger subviewCount = self.subviews.count;
    CGFloat btnW = self.frame.size.width / (subviewCount * 1.0);
    CGFloat btnH = self.frame.size.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    for (NSInteger i = 0; i < subviewCount; i++)
    {
        btnX = i * btnW;
        UIButton * btn = self.subviews[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    
}


- (void)setShowEmotionButton:(BOOL)showEmotionButton
{
    _showEmotionButton = showEmotionButton;
    
    if (showEmotionButton)
    {
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}


- (void)toolsBarButtonClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolsBar:didClickedButton:)])
    {
        [self.delegate composeToolsBar:self didClickedButton:btn.tag];
    }
}


@end
