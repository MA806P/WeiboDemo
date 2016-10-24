//
//  MYZStatusFrameMiddle.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusFrameMiddle.h"
#import "MYZStatusRetweeted.h"
#import "MYZUserInfo.h"


@implementation MYZStatusFrameMiddle


-(void)setStatusRetweeted:(MYZStatusRetweeted *)statusRetweeted
{
    _statusRetweeted = statusRetweeted;
    
    
    //判断是否有转发微博
    if (statusRetweeted == nil)
    {
        self.frame = CGRectZero;
        self.frameReText = CGRectZero;
        return;
    }
    
    //转发微博的用户名
    NSString * textStr = [NSString stringWithFormat:@"@%@: %@",statusRetweeted.user.name, statusRetweeted.text];
    
    CGFloat textX = StatusMarginLR;
    CGFloat textY = StatusMarginReTextT;
    CGFloat textW = SCREEN_W - textX * 2.0;
    CGFloat textH = [textStr myz_stringSizeWithMaxSize:CGSizeMake(textW, MAXFLOAT) andFont:[UIFont systemFontOfSize:StatusFontTextSize]].height;
    
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
            NSInteger rowCount = (picsCount - 1) / 3;
            NSInteger columnCount = rowCount > 0 ? 2 : (picsCount - 1) % 3;
            
            picContentW = (statusPicWH + StatusMarginPics) * columnCount + statusPicWH;
            picContentH = (statusPicWH + StatusMarginPics) * rowCount + statusPicWH;
        }
        
        self.frameRePicContent = CGRectMake(textX, CGRectGetMaxY(self.frameReText) + StatusMarginReTextB, picContentW, picContentH);
    }
    
    
    
    self.frame = CGRectMake(0, 0, SCREEN_W, CGRectGetMaxY(self.frameRePicContent));
        
    
}


@end
