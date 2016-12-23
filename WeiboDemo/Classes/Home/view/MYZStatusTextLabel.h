//
//  MYZStatusTextLabel.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/13.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZStatusTextItem;

FOUNDATION_EXPORT NSString * const LinkTextKey;//富文本可点击连接的标志
FOUNDATION_EXPORT CGFloat const StatusFontTextSize; //微博正文字体大小

@interface MYZStatusTextLabel : UIView

/** 微博正文富文本信息 */
@property (nonatomic, strong) NSAttributedString * attributedString;

/** 点击文本中的超链接回调 */
@property (nonatomic, copy) void(^statusTextLabelBlock)(MYZStatusTextItem * item);

@end
