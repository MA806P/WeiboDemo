//
//  MYZStatusFrameMiddle.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZStatusOriginal;

FOUNDATION_EXPORT CGFloat const StatusMarginLR; //微博cell左右间距
FOUNDATION_EXPORT CGFloat const StatusMarginReTextT; //转发微博的正文和上部间距
FOUNDATION_EXPORT CGFloat const StatusMarginReTextB; //转发微博的正文和下部部间距

FOUNDATION_EXPORT CGFloat const StatusFontTextSize; //微博正文字体大小

FOUNDATION_EXPORT CGFloat const StatusMarginPics; //配图之间的间隙


@interface MYZStatusFrameMiddle : NSObject

/** 微博状态的转发的微博数据 */
@property (nonatomic, strong) MYZStatusOriginal * status;


/** 转发微博的文字标签frame */
@property (nonatomic, assign) CGRect frameReText;

/** 转发微博的图片背景视图frame */
@property (nonatomic, assign) CGRect frameRePicContent;


/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

@end
