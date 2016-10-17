//
//  MYZStatusFrameMiddle.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZStatus;

@interface MYZStatusFrameMiddle : NSObject

/** 微博状态的原始数据 */
@property (nonatomic, strong) MYZStatus * status;

/** 原创微博的文字标签 */
@property (nonatomic, assign) CGRect frameText;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

@end
