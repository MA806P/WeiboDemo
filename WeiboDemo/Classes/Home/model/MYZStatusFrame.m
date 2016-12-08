//
//  MYZStatusFrame.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusFrame.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusRetweeted.h"
#import "MYZStatusFrameTop.h"
#import "MYZStatusFrameMiddle.h"

#import "RegexKitLite.h"
#import "MYZStatusTextItem.h"
#import "MYZEmotion.h"
#import "MYZEmotionTool.h"
#import "MYZEmotionAttachment.h"

CGFloat const StatusBottomH = 37.0; //底部转发评论点赞栏 高度

CGFloat const StatusMarginLR = 13.0; //微博cell左右间距
CGFloat const StatusMarginT = 15.0; //微博cell上部间距
CGFloat const StatusMarginIconName = 15.0; //头像和昵称左右间距
CGFloat const StatusMarginIconText = 10.0; //头像和微博正文上下间距
CGFloat const StatusMarginTextB = 8.0; //原创正文下部间距
CGFloat const StatusMarginTimeFrom = 5.0; //时间和来源左右间距

CGFloat const StatusMarginReTextT = 10.0; //转发微博的正文和上部间距
CGFloat const StatusMarginReTextB = 8.0; //转发微博的正文和下部部间距

CGFloat const StatusFontNameSize = 14.0; //昵称字体大小
CGFloat const StatusFontTimeFromSize = 12.0; //时间和来源字体大小
CGFloat const StatusFontTextSize = 14.0; //微博正文字体大小

CGFloat const StatusMarginBetweenCell = 6.0; //两微博之间的间隙,上方空出

//CGFloat StatusPicsWH; //微博配图的长宽，相等，根据屏幕的宽计算除3，一排三张
CGFloat const StatusMarginPics = 6.0; //配图之间的间隙

#define StatusTextHighlightColor MYZColor(88, 61, 253)


@implementation MYZStatusFrame

+ (id)statusFrameWithStatus:(MYZStatusOriginal *)status
{
    MYZStatusFrame * statusFrame = [[self alloc] init];
    statusFrame.status = status;
    return statusFrame;
}


- (void)setStatus:(MYZStatusOriginal *)status
{
    _status = status;
    //处理微博内容，富文本。原创内容和转发的内容分开
    status.attributedText = [self regexResultsWithText:status.text];
//    MYZStatusRetweeted * re = status.retweeted_status;
//    if (re)
//    {
//        re.attributedText = [self regexResultsWithText:re.text];
//    }
    
    //计算上部frame
    [self calcuateFrameTop];
    
    //计算内容的frame
    [self calcuateFrameMiddle];
    
    //计算评论的frame, 顺便得出cell的高度
    [self calcuateFrameBottom];
    
}

//计算上部frame
- (void)calcuateFrameTop
{
    MYZStatusFrameTop * frameTop = [[MYZStatusFrameTop alloc] init];
    frameTop.status = self.status;
    self.frameTop = frameTop;
}

//计算内容的frame
- (void)calcuateFrameMiddle
{
    MYZStatusFrameMiddle * frameMiddle = [[MYZStatusFrameMiddle alloc] init];
    frameMiddle.statusRetweeted = self.status.retweeted_status;
    
    CGRect mFrame = frameMiddle.frame;
    mFrame.origin.y = CGRectGetMaxY(self.frameTop.frame);
    frameMiddle.frame = mFrame;
    
    self.frameMiddle = frameMiddle;
}

//计算评论的frame
- (void)calcuateFrameBottom
{
    self.frameBottom = CGRectMake(0, CGRectGetMaxY(self.frameMiddle.frame), SCREEN_W, StatusBottomH);
    
    CGFloat statusW = CGRectGetMaxY(self.frameBottom);
    self.cellHeight = statusW;
    self.frame = CGRectMake(0, 0, SCREEN_W, statusW);
}



//处理微博内容，处理字符串，显示不同的格式，@、##、连接、、
- (NSAttributedString *)regexResultsWithText:(NSString *)text
{
    if (text == nil) { return nil; }
    
    //使用过正则表达式进行匹配信息
    //匹配后被截为各个小段，放到数组中保存
    NSMutableArray * textItems = [NSMutableArray array];
    
    /**
     *  为啥要先放在数组中保存一下，还排序呢？
     *  不能直接替换掉表情的，直接替换后面的就会错位，对不准，只能是按顺序来进行拼接
     */

    
    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.type = StatusTextItemTypeEmotion;
        textItem.range = *capturedRanges;
        textItem.text = *capturedStrings;
        [textItems addObject:textItem];
    }];
    
    // 匹配#话题#
    NSString *topicRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
    [text enumerateStringsMatchedByRegex:topicRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.type = StatusTextItemTypeTopic;
        textItem.range = *capturedRanges;
        textItem.text = *capturedStrings;
        [textItems addObject:textItem];
    }];
    
    // 匹配@...
    NSString *userRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-]+ ?";
    [text enumerateStringsMatchedByRegex:userRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.type = StatusTextItemTypeUser;
        textItem.range = *capturedRanges;
        textItem.text = *capturedStrings;
        [textItems addObject:textItem];
    }];
    
    // 匹配超链接
    NSString *urlRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
    [text enumerateStringsMatchedByRegex:urlRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.type = StatusTextItemTypeUrl;
        textItem.range = *capturedRanges;
        textItem.text = *capturedStrings;
        [textItems addObject:textItem];
    }];
    
    
    
    //被截成的小段进行排序
    [textItems sortUsingComparator:^NSComparisonResult(MYZStatusTextItem * obj1, MYZStatusTextItem * obj2) {
        NSUInteger loc1 = obj1.range.location;
        NSUInteger loc2 = obj2.range.location;
        return [@(loc2) compare:@(loc1)];
    }];
    
    
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    UIFont * statusTextFont = [UIFont systemFontOfSize:StatusFontTextSize];
    CGFloat fontlineH = statusTextFont.lineHeight;
    
    //遍历各个小段, 拼接attributedString
    for (MYZStatusTextItem * textItem in textItems)
    {
        switch (textItem.type) {
            case StatusTextItemTypeEmotion:
            {
                MYZEmotion * emotion = [MYZEmotionTool emotionWithDesc:textItem.text];
                if(emotion)
                {
                    MYZEmotionAttachment * attachment = [[MYZEmotionAttachment alloc] init];
                    attachment.emotion = emotion;
                    attachment.bounds = CGRectMake(0, -3, fontlineH, fontlineH);
                    [attributedText replaceCharactersInRange:textItem.range withAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                }
                break;
            }
            case StatusTextItemTypeUser:
            case StatusTextItemTypeTopic:
            case StatusTextItemTypeUrl:
            {
                [attributedText addAttribute:NSForegroundColorAttributeName value:StatusTextHighlightColor range:textItem.range];
                break;
            }
            default:
                break;
        }
    }
    
    return attributedText;
}




@end
