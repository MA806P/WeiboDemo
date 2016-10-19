//
//  MYZStatusFrameMiddle.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZStatus;

FOUNDATION_EXPORT CGFloat const StatusMarginLR; //微博cell左右间距
FOUNDATION_EXPORT CGFloat const StatusMarginReTextT; //转发微博的正文和上部间距
FOUNDATION_EXPORT CGFloat const StatusMarginReTextB; //转发微博的正文和下部部间距

FOUNDATION_EXPORT CGFloat const StatusFontTextSize; //微博正文字体大小

@interface MYZStatusFrameMiddle : NSObject

/** 微博状态的原始数据 */
@property (nonatomic, strong) MYZStatus * status;


/** 转发微博的文字标签 */
@property (nonatomic, assign) CGRect frameReText;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

@end
