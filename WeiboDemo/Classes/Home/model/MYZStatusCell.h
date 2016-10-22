//
//  MYZStatusCell.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/19.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZStatusFrame;

FOUNDATION_EXPORT CGFloat const StatusFontNameSize; //昵称字体大小
FOUNDATION_EXPORT CGFloat const StatusFontTimeFromSize; //时间和来源字体大小
FOUNDATION_EXPORT CGFloat const StatusFontTextSize; //微博正文字体大小

FOUNDATION_EXPORT CGFloat const StatusMarginTimeFrom; //时间和来源左右间距
FOUNDATION_EXPORT CGFloat const StatusMarginBetweenCell; //两微博之间的间隙

@interface MYZStatusCell : UITableViewCell

/** 微博数据,包括微博内容和各个空间的frame */
@property (nonatomic, strong) MYZStatusFrame * statusFrame;


@end
