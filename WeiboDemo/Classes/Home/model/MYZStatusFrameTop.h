//
//  MYZStatusFrameTop.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZStatus;

@interface MYZStatusFrameTop : NSObject


/** 头像 */
@property (nonatomic, assign) CGRect frameIcon;
/** 昵称 */
@property (nonatomic, assign) CGRect frameName;

/** 会员图标 */
@property (nonatomic, assign) CGRect frameVip;

/** 时间标签 */
@property (nonatomic, assign) CGRect frameTime;

/** 来源标签 */
@property (nonatomic, assign) CGRect frameSource;

/** 微博内容标签 */
@property (nonatomic, assign) CGRect frameText;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

/** 微博数据 */
@property (nonatomic, strong) MYZStatus * status;

@end
