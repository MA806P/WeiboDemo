//
//  MYZComposeTextView.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/26.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZComposeTextView.h"
#import "MYZEmotion.h"

@interface MYZComposeTextView ()

@property (nonatomic, weak) UILabel * placeholderLabel;

@end

@implementation MYZComposeTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = YES; //垂直方向滚动弹簧效果
        self.showsVerticalScrollIndicator = NO;
        
        UIFont * textFont = [UIFont systemFontOfSize:17];
        self.font = textFont;
        
        UILabel * placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.font = textFont;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
        //监听自己的输入的文字变化，来判断是否显示placeholder
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textViewTextDidChange
{
    self.placeholderLabel.hidden = (self.text.length != 0);
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textViewTextDidChange];
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.placeholderLabel.text = placeholder;
    
    //重新计算placeholder的大小
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelX = 5.0;
    CGFloat labelY = 10.0;
    CGFloat labelMaxW = self.width - labelX * 2.0;
    
    CGSize placeholderSize = [self.placeholder myz_stringSizeWithMaxSize:CGSizeMake(labelMaxW, MAXFLOAT) andFont:self.placeholderLabel.font];
    self.placeholderLabel.frame = CGRectMake(labelX, labelY, placeholderSize.width, placeholderSize.height);
    
}


#pragma mark - 表情输入处理

- (void)appendEmotion:(MYZEmotion *)emotion
{
    if(emotion.emoji) //emoji表情实际就是一个字符串，自显示
    {
        [self insertText:emotion.emoji];
    }
    else //图片表情
    {
        
    }
    
}


@end
