//
//  MYZStatusTopView.h
//  WeiboDemo
//
//  Created by MA806P on 2016/10/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const StatusFontNameSize; //昵称字体大小
FOUNDATION_EXPORT CGFloat const StatusFontTimeFromSize; //时间和来源字体大小

FOUNDATION_EXPORT CGFloat const StatusMarginTimeFrom; //时间和来源左右间距



@class MYZStatusFrameTop;

@interface MYZStatusTopView : UIImageView

/** 微博状态和frame值模型 */
@property (nonatomic, strong) MYZStatusFrameTop * statusFrameTop;

/** 微博cell点击状态，根据值来调整背景图 */
@property (nonatomic, assign) MYZStatusCellType cellType;

@end
