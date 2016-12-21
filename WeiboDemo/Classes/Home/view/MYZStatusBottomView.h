//
//  MYZStatusBottomView.h
//  WeiboDemo
//
//  Created by MA806P on 2016/10/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const StatusMarginLR; //微博cell左右间距
FOUNDATION_EXPORT CGFloat const StatusBottomH; //底部转发评论点赞栏 高度
FOUNDATION_EXPORT NSString * const StatusRepostNoticKey;//转发点击发送通知的key
FOUNDATION_EXPORT NSString * const StatusCommentNoticKey;//评论点击发送通知的key
FOUNDATION_EXPORT NSString * const StatusLikeNoticKey;//赞点击发送通知的key

@class MYZStatusOriginal;

@interface MYZStatusBottomView : UIImageView

/** 微博状态和frame值模型 */
@property (nonatomic, strong) MYZStatusOriginal * status;

/** 微博cell点击状态，根据值来调整背景图 */
@property (nonatomic, assign) MYZStatusCellType cellType;

@end
