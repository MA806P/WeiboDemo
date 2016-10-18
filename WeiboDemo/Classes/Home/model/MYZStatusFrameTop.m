//
//  MYZStatusFrameTop.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusFrameTop.h"
#import "MYZStatus.h"
#import "NSString+MYZ.h"

@implementation MYZStatusFrameTop



- (void)setStatus:(MYZStatus *)status
{
    _status = status;
    
    if (status == nil)
    {
        self.frame = CGRectZero;
        return;
    }
    
    
    CGFloat marginT = 15;
    CGFloat marginL = 13;
    
    //头像
    self.frameIcon = CGRectMake(marginL, marginT, 40, 40);
    
    //名字
    CGFloat marginIconName = 15;
    CGFloat nameX = CGRectGetMaxX(self.frameName) + marginIconName;
    CGFloat nameY = self.frameName.origin.y;
    CGFloat nameW = self.frame.size.width - nameX;
    CGFloat nameH = 25;
    self.frameName = CGRectMake(nameX, nameY, nameW, nameH);
    
    //时间
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.frameName);
    CGFloat timeH = 15;
    CGFloat timeW = [_status.created_at myz_stringSizeWithMaxSize:CGSizeMake(nameW, timeH) andFont:[UIFont systemFontOfSize:12]].width;
    self.frameTime = CGRectMake(timeX, timeY, timeW, timeH);
    
    //来源
    CGFloat sourceX = CGRectGetMaxX(self.frameTime) + 5 ;
    CGFloat sourceW = self.frame.size.width - sourceX;
    self.frameSource = CGRectMake(sourceX, timeY, sourceW, timeH);
    
    //微博内容
    CGFloat marginIconText = 10;
    CGFloat textX = self.frameIcon.origin.x;
    CGFloat textY = CGRectGetMaxY(self.frameIcon) + marginIconText;
    CGFloat textW = self.frame.size.width - marginL * 2;
    CGFloat textH = [self.status.text myz_stringSizeWithMaxSize:CGSizeMake(textW, MAXFLOAT) andFont:[UIFont systemFontOfSize:14]].height;
    self.frameText = CGRectMake(textX, textY, textW, textH);
    
    self.frame = CGRectMake(0, 0, SCREEN_W, CGRectGetMaxY(self.frameText));
}



@end
