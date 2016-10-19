//
//  MYZStatusFrameMiddle.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusFrameMiddle.h"
#import "MYZStatus.h"
#import "MYZStatusRetweeted.h"
#import "MYZUserInfo.h"
#import "NSString+MYZ.h"

@implementation MYZStatusFrameMiddle


- (void)setStatus:(MYZStatus *)status
{
    _status = status;
    
    if (status == nil)
    {
        self.frame = CGRectZero;
        return;
    }
  
    
    //判断是否有转发微博
    if(status.retweeted_status != nil)
    {
        //转发微博的用户名
        NSString * textStr = [NSString stringWithFormat:@"@%@: %@",status.retweeted_status.user.name, status.retweeted_status.text];
        
        CGFloat textX = StatusMarginLR;
        CGFloat textY = StatusMarginReTextT;
        CGFloat textW = SCREEN_W - textX * 2.0;
        CGFloat textH = [textStr myz_stringSizeWithMaxSize:CGSizeMake(textW, MAXFLOAT) andFont:[UIFont systemFontOfSize:StatusFontTextSize]].height;
        
        self.frameReText = CGRectMake(textX, textY, textW, textH);
        
        self.frame = CGRectMake(0, 0, SCREEN_W, textH + StatusMarginReTextT + StatusMarginReTextB);
        
    }
    else
    {
        self.frame = CGRectZero;
        self.frameReText = CGRectZero;
    }
    
    
    
}


@end
