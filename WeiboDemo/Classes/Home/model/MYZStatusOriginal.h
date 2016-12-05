//
//  MYZStatusOriginal.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatus.h"

@class MYZStatusRetweeted;

@interface MYZStatusOriginal : MYZStatus

/** 被转发的原微博信息字段，当该微博为转发微博时返回 */
@property MYZStatusRetweeted *retweeted_status;

@end
