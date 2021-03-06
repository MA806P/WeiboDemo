//
//  MYZStatusFrameTop.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZStatusOriginal;


FOUNDATION_EXPORT CGFloat const StatusMarginLR; //微博cell左右间距
FOUNDATION_EXPORT CGFloat const StatusMarginT; //微博cell上部间距
FOUNDATION_EXPORT CGFloat const StatusMarginIconName; //头像和昵称左右间距
FOUNDATION_EXPORT CGFloat const StatusMarginIconText; //头像和微博正文上下间距
FOUNDATION_EXPORT CGFloat const StatusMarginTextB; //原创正文下部间距
FOUNDATION_EXPORT CGFloat const StatusMarginTimeFrom; //时间和来源左右间距

FOUNDATION_EXPORT CGFloat const StatusFontNameSize; //昵称字体大小
FOUNDATION_EXPORT CGFloat const StatusFontTimeFromSize; //时间和来源字体大小
FOUNDATION_EXPORT CGFloat const StatusFontTextSize; //微博正文字体大小

FOUNDATION_EXPORT CGFloat const StatusMarginBetweenCell; //两微博之间的间隙,上方空出

FOUNDATION_EXPORT CGFloat const StatusMarginPics; //配图之间的间隙

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

/** 原创微博配图 */
@property (nonatomic, assign) CGRect framePicsContent;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

/** 微博数据 */
@property (nonatomic, strong) MYZStatusOriginal * status;

@end
