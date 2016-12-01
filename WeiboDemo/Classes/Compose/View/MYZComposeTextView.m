//
//  MYZComposeTextView.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/26.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZComposeTextView.h"
#import "MYZEmotion.h"
#import "MYZEmotionAttachment.h"

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
    self.placeholderLabel.hidden = self.hasText;//(self.text.length != 0);
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textViewTextDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
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
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        MYZEmotionAttachment * attachment = [[MYZEmotionAttachment alloc] init];
        attachment.emotion = emotion;
        attachment.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString * attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        //找到光标所在的位置
        NSInteger insertIndex = self.selectedRange.location;
        
        //输入表情图片
        [attributedText insertAttributedString:attachmentString atIndex:insertIndex];
        
        //设置字体，不然输入表情图片后后面的字体会变小
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        //重新赋值光标会跑到最后面
        self.attributedText = attributedText;
        
        //设置光标的位置在原来的位置
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
    }
    
}

//获取输入的文字内容包括表情，带图片的表情用中括号+文字表示
- (NSString *)realText
{
    NSMutableString * text = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        MYZEmotionAttachment * attchment = attrs[@"NSAttachment"];
        if (attchment)
        {
            //带有富文本的
            [text appendString:attchment.emotion.chs];
        }
        else
        {
            //普通字符串
            NSString * subText = [[self.attributedText attributedSubstringFromRange:range] string];
            [text appendString:subText];
        }
        
    }];
    
    return text;
}




@end
