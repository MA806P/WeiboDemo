//
//  MYZStatusFrame.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusFrame.h"
#import "MYZStatus.h"
#import "MYZStatusFrameTop.h"
#import "MYZStatusFrameMiddle.h"

CGFloat const BottomH = 37.0;

@implementation MYZStatusFrame

+ (id)statusFrameWithStatus:(MYZStatus *)status
{
    MYZStatusFrame * statusFrame = [[self alloc] init];
    statusFrame.status = status;
    return statusFrame;
}


- (void)setStatus:(MYZStatus *)status
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
    frameMiddle.status = self.status;
    self.frameMiddle = frameMiddle;
}

//计算评论的frame
- (void)calcuateFrameBottom
{
    self.frameBottom = CGRectMake(0, CGRectGetMaxY(self.frameMiddle.frame), SCREEN_W, BottomH);
    
    self.cellHeight = CGRectGetMaxY(self.frameBottom);
}
@end
