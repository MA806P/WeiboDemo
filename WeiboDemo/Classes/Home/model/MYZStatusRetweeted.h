//
//  MYZStatusRetweeted.h
//  WeiboDemo
//
//  Created by MA806P on 2016/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYZStatus.h"


//RLM_ARRAY_TYPE(MYZStatusPic)

@interface MYZStatusRetweeted : RLMObject


/** 是否已收藏，true：是，false：否 */
@property BOOL favorited;

/** 微博创建时间 */
@property NSString *created_at;

/** 微博来源 */
@property NSString *source;

/** 微博MID */
@property NSString *mid;

/** 微博配图 */
@property RLMArray<MYZStatusPic> *pic_urls;
/** 微博信息内容 */
@property NSString *text;

/** 微博作者的用户信息字段 */
@property MYZUserInfo *user;

/** 评论数 */
@property NSInteger comments_count;
/** 转发数 */
@property NSInteger reposts_count;
/** 表态数 */
@property NSInteger attitudes_count;


/** GIF */
@property NSString *gif_ids;

/**缩略图片地址，没有时不返回此字段*/
@property NSString * thumbnail_pic;
/**中等尺寸图片地址，没有时不返回此字段*/
@property NSString * bmiddle_pic;
/**原始图片地址，没有时不返回此字段*/
@property NSString * original_pic;


/** 是否被截断，true：是，false：否 */
@property BOOL truncated;
/** 长微博 */
@property BOOL isLongText;

@end