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

@class MYZStatus;

@interface MYZStatusBottomView : UIImageView

/** 微博状态和frame值模型 */
@property (nonatomic, strong) MYZStatus * status;

/** 微博cell点击状态，根据值来调整背景图 */
@property (nonatomic, assign) MYZStatusCellType cellType;

@end
