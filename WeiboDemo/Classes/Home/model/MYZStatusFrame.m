//
//  MYZStatusFrame.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusFrame.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusFrameTop.h"
#import "MYZStatusFrameMiddle.h"

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
@end
