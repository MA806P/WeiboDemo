//
//  MYZStatusFrame.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZStatusOriginal, MYZStatusFrameTop, MYZStatusFrameMiddle;

@interface MYZStatusFrame : NSObject

/** 微博状态的原始数据 */
@property (nonatomic, strong) MYZStatusOriginal * status;


/** 微博状态cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

/** cell上部分frame */
@property (nonatomic, strong) MYZStatusFrameTop * frameTop;

/** cell中间部分内容frame */
@property (nonatomic, strong) MYZStatusFrameMiddle * frameMiddle;

/** cell下部分评论等frame */
@property (nonatomic, assign) CGRect frameBottom;

+ (id)statusFrameWithStatus:(MYZStatusOriginal *)status;

@end
