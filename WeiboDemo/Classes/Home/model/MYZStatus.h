//
//  MYZStatus.h
//  WeiboDemo
//
//  Created by MA806P on 2016/10/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>


RLM_ARRAY_TYPE(MYZStatusPic)

@interface MYZStatus : RLMObject

/** 是否已收藏，true：是，false：否 */
@property BOOL favorited;

/** 微博创建时间 */
@property NSString *created_at;
/** 处理过的创建时间 */
@property (nonatomic, copy) NSString * createdStr;

/** 微博来源 */
@property NSString *source;
///** 处理过的微博来源 */
//@property (nonatomic, copy) NSString * sourceStr;

/** 微博MID */
@property NSString *mid;
/** 字符串型的微博ID 和上面的一样*/
//@property NSString *idstr;

/** 微博配图 */
@property RLMArray<MYZStatusPic> *pic_urls;

/** 微博信息内容 */
@property NSString *text;
/** 微博处理后的内容，富文本*/
@property NSAttributedString *attributedText;

/** 微博作者的用户信息字段 */
@property MYZUserInfo *user;

/** 评论数 */
@property NSInteger comments_count;
/** 转发数 */
@property NSInteger reposts_count;
/** 表态数 */
@property NSInteger attitudes_count;



///** GIF */
//@property NSString *gif_ids;
///**缩略图片地址，没有时不返回此字段*/
//@property NSString * thumbnail_pic;
///**中等尺寸图片地址，没有时不返回此字段*/
//@property NSString * bmiddle_pic;
///**原始图片地址，没有时不返回此字段*/
//@property NSString * original_pic;


/** 是否被截断，true：是，false：否 */
@property BOOL truncated;
/** 长微博 */
@property BOOL isLongText;


/** 微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号 */
//@property NSDictionary *visible;
/** object 地理信息字段 */
//@property NSDictionary * geo;


/** 公告 */
//@property NSInteger is_show_bulletin;


///** （暂未支持）回复人UID */
//@property NSString *in_reply_to_user_id;
///** 暂未支持）回复人昵称 */
//@property NSString *in_reply_to_screen_name;
///** （暂未支持）回复ID */
//@property NSString *in_reply_to_status_id;


///**  */
//@property NSInteger hasActionTypeCard;
///**  */
//@property NSInteger source_type;
///**  */
//@property NSArray *hot_weibo_tags;
///**  */
//@property NSArray *text_tag_tips;
///**  */
//@property NSInteger source_allowclick;
///**  */
//@property NSInteger biz_feature;
///**  */
//@property NSInteger positive_recom_flag;
///**  */
//@property NSArray *darwin_tags;
///**  */
//@property NSString *rid;
///**  */
//@property NSInteger userType;


@end
