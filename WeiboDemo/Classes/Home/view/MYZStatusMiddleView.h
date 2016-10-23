//
//  MYZStatusMiddleView.h
//  WeiboDemo
//
//  Created by MA806P on 2016/10/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const StatusFontTextSize; //微博正文字体大小

@class MYZStatusFrameMiddle;

@interface MYZStatusMiddleView : UIImageView


/** 微博状态和frame值模型 */
@property (nonatomic, strong) MYZStatusFrameMiddle * statusFrameMiddle;

/** 微博cell点击状态，根据值来调整背景图 */
@property (nonatomic, assign) MYZStatusCellType cellType;

@end
