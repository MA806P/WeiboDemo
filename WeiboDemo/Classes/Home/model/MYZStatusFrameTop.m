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
    
    
    
    //头像
    self.frameIcon = CGRectMake(StatusMarginLR, StatusMarginT, 40, 40);
    
    //名字
    CGFloat nameX = CGRectGetMaxX(self.frameIcon) + StatusMarginIconName;
    CGFloat nameY = self.frameIcon.origin.y;
    CGFloat nameW = SCREEN_W - nameX;
    CGFloat nameH = 25;
    self.frameName = CGRectMake(nameX, nameY, nameW, nameH);
    
    //时间
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.frameName);
    CGFloat timeH = 15;
    CGFloat timeW = [_status.createdStr myz_stringSizeWithMaxSize:CGSizeMake(nameW, timeH) andFont:[UIFont systemFontOfSize:StatusFontTimeFromSize]].width;
    self.frameTime = CGRectMake(timeX, timeY, timeW, timeH);
    
    //来源
    CGFloat sourceX = CGRectGetMaxX(self.frameTime) + 5 ;
    CGFloat sourceW = SCREEN_W - sourceX;
    self.frameSource = CGRectMake(sourceX, timeY, sourceW, timeH);
    
    //微博内容
    CGFloat textX = self.frameIcon.origin.x;
    CGFloat textY = CGRectGetMaxY(self.frameIcon) + StatusMarginIconText;
    CGFloat textW = SCREEN_W - StatusMarginLR * 2;
    CGFloat textH = [self.status.text myz_stringSizeWithMaxSize:CGSizeMake(textW, MAXFLOAT) andFont:[UIFont systemFontOfSize:StatusFontTextSize]].height;
    self.frameText = CGRectMake(textX, textY, textW, textH);
    
    self.frame = CGRectMake(0, 0, SCREEN_W, CGRectGetMaxY(self.frameText)+StatusMarginTextB);
}



@end
