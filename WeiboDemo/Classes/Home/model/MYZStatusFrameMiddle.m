//
//  MYZStatusFrameMiddle.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusFrameMiddle.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusRetweet.h"
#import "MYZUserInfo.h"


@implementation MYZStatusFrameMiddle


-(void)setStatus:(MYZStatusOriginal *)status
{
    _status = status;
    
    //转发的微博模型
    MYZStatusRetweet * statusRetweeted = status.retweeted_status;
    
    //判断是否有转发微博
    if (statusRetweeted == nil)
    {
        self.frame = CGRectZero;
        self.frameReText = CGRectZero;
        return;
    }
    
    //转发微博的内容，带有@用户名的转发的内容
    
    CGFloat textX = StatusMarginLR;
    CGFloat textY = StatusMarginReTextT;
    CGFloat textW = SCREEN_W - textX * 2.0;
    //CGFloat textH = [statusRetweeted.text myz_stringSizeWithMaxSize:CGSizeMake(textW, MAXFLOAT) andFont:[UIFont systemFontOfSize:StatusFontTextSize]].height + 2;
    CGFloat textH = [self.status.reAttributedText boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    self.frameReText = CGRectMake(textX, textY, textW, textH);
    
    //转发微博的图片显示视图
    self.frameRePicContent = CGRectMake(textX, CGRectGetMaxY(self.frameReText) + StatusMarginReTextB, 0, 0);
    NSInteger picsCount = statusRetweeted.pic_urls.count;
    if(picsCount > 0)
    {
        CGFloat picContentW = (SCREEN_W - textX*2.0);
        CGFloat picContentH = 0.0;
        CGFloat statusPicWH = (picContentW - StatusMarginPics*2) /3.0;
        
        if(picsCount == 1)
        {
            picContentW *= 0.5;
            picContentH = picContentW;
        }
        else if (picsCount == 4)
        {
            picContentW = statusPicWH * 2.0 + StatusMarginPics;
            picContentH = picContentW;
        }
        else
        {
            //注意其他的无论几张, 宽度都是固定的, 两张 三张 都是那么长, 没有的不显示
            NSInteger rowCount = (picsCount - 1) / 3;
            picContentW = (statusPicWH + StatusMarginPics) * 2 + statusPicWH;
            picContentH = (statusPicWH + StatusMarginPics) * rowCount + statusPicWH;
        }
        
        self.frameRePicContent = CGRectMake(textX, CGRectGetMaxY(self.frameReText) + StatusMarginReTextB, picContentW, picContentH);
    }
    
    
    
    self.frame = CGRectMake(0, 0, SCREEN_W, CGRectGetMaxY(self.frameRePicContent));
        
    
}


@end
