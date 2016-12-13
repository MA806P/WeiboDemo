//
//  MYZStatusTextLabel.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/13.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusTextLabel.h"
#import "MYZStatusTextItem.h"

static NSInteger const StatusTextLabelLinkBgTag = 123456;

@interface MYZStatusTextLabel ()

@property (nonatomic, weak) UITextView * textView;

@property (nonatomic, strong) NSMutableArray * linkArray;

@end



@implementation MYZStatusTextLabel

//微博正文中所有可以点击的链接
- (NSMutableArray *)linkArray
{
    if (_linkArray == nil)
    {
        NSMutableArray * linkArray = [NSMutableArray array];
        
        [self.attributedString enumerateAttributesInRange:NSMakeRange(0, self.attributedString.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            
            NSString * linkText = attrs[LinkTextKey];
            if (linkText == nil) { return; }
            
            MYZStatusTextItem * linkTextItem = [[MYZStatusTextItem alloc] init];
            linkTextItem.text = linkText;
            linkTextItem.range = range;
            if ([linkText hasPrefix:@"@"]) { linkTextItem.type = StatusTextItemTypeUser; }
            else if ([linkText hasPrefix:@"#"]) { linkTextItem.type = StatusTextItemTypeTopic; }
            else if ([linkText hasPrefix:@"http"]) { linkTextItem.type = StatusTextItemTypeUrl; }
            
            NSMutableArray * rects = [NSMutableArray array];
            
            // 设置选中的字符范围
            self.textView.selectedRange = range;
            // 算出选中的字符范围的边框
            NSArray *selectionRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            for (UITextSelectionRect *selectionRect in selectionRects) {
                if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) continue;
                [rects addObject:selectionRect];
            }
            linkTextItem.rects = rects;
            
            [linkArray addObject:linkTextItem];
        }];
        
        _linkArray = linkArray;
    }
    return _linkArray;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //用textView显示是因为textView有选择文字的属性
        UITextView * textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        //textView.editable = NO;
        textView.userInteractionEnabled = NO;
        textView.textContainerInset = UIEdgeInsetsMake(-5, -5, 0, -5);
        textView.font = [UIFont systemFontOfSize:StatusFontTextSize];
        [self addSubview:textView];
        self.textView = textView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    
    self.textView.attributedText = attributedString;
    self.linkArray = nil;
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    MYZStatusTextItem * linkTextItem = [self touchLinkWithPoint:touchPoint];
    [self setLinkTextItemHiglighted:linkTextItem];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    MYZStatusTextItem * linkTextItem = [self touchLinkWithPoint:touchPoint];
    if (linkTextItem)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:StatusTextLinkNoticKey object:linkTextItem];
    }
    [self removeLinkHiglightedView];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeLinkHiglightedView];
    });
}

#pragma mark - 连接处理方法

//根据触摸点，判断点击的链接
- (MYZStatusTextItem *)touchLinkWithPoint:(CGPoint)point
{
    __block MYZStatusTextItem * linkTextItem = nil;
    
    [self.linkArray enumerateObjectsUsingBlock:^(MYZStatusTextItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        for (UITextSelectionRect * selectionRect in obj.rects)
        {
            if (CGRectContainsPoint(selectionRect.rect, point))
            {
                linkTextItem = obj;
                break;
            }
        }
    }];

    return linkTextItem;
}

//根据点击设置背景色，高亮状态
- (void)setLinkTextItemHiglighted:(MYZStatusTextItem *)linkTextItem
{
    if (linkTextItem == nil) { return; }
    
    for (UITextSelectionRect * selectionRect in linkTextItem.rects)
    {
        UIView * higlightedView = [[UIView alloc] initWithFrame:selectionRect.rect];
        higlightedView.backgroundColor = MYZColor(203, 240, 252);
        higlightedView.layer.cornerRadius = 5;
        higlightedView.tag = StatusTextLabelLinkBgTag;
        [self insertSubview:higlightedView atIndex:0];
    }
    
}

//移除高亮背景色
- (void)removeLinkHiglightedView
{
    for (UIView * view in self.subviews)
    {
        if (view.tag == StatusTextLabelLinkBgTag)
        {
            [view removeFromSuperview];
        }
    }
}

@end
