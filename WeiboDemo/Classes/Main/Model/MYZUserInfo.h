//
//  MYZUserInfo.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/10.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYZUserInfo : RLMObject



/** 字符串型的用户UID */
@property NSString *idstr;

/** 用户昵称 */
@property NSString *screen_name;

/** 友好显示名称 */
@property NSString *name;

/** 用户所在省级ID */
@property NSString *province;

/** 用户所在城市ID */
@property NSString *city;

/** 用户所在地 */
@property NSString *location;

/** 用户个人描述 */
@property NSString *desc;


/** 用户头像地址（中图），50×50像素 */
@property NSString *profile_image_url;

/** 性别，m：男、f：女、n：未知 */
@property NSString *gender;

/** 粉丝数 */
@property NSInteger followers_count;

/** 关注数 */
@property NSInteger friends_count;

/** 微博数 */
@property NSInteger statuses_count;

/** 收藏数 */
@property NSInteger favourites_count;

/** 用户创建（注册）时间 */
@property NSString *created_at;

/** 是否是微博认证用户，即加V用户，true：是，false：否 */
@property BOOL verified;

/** 是否允许所有人对我的微博进行评论 */
@property BOOL allow_all_comment;

/** 用户头像地址（大图），180×180像素 */
@property NSString *avatar_large;

/** 用户头像地址（高清），高清头像原图 */
@property NSString *avatar_hd;

/** 该用户是否关注当前登录用户，true：是，false：否 */
@property BOOL follow_me;

/** 用户的在线状态，0：不在线、1：在线 */
@property NSInteger online_status;

/** 个人中心背景图 */
@property NSString *cover_image_phone;




/** 用户UID */
//@property (nonatomic ,assign) NSInteger uid;

///** 字符串型的用户UID */
//@property (nonatomic ,copy) NSString *idstr;
//
///** 用户昵称 */
//@property (nonatomic ,copy) NSString *screen_name;
//
///** 友好显示名称 */
//@property (nonatomic ,copy) NSString *name;
//
///** 用户所在省级ID */
//@property (nonatomic ,copy) NSString *province;
//
///** 用户所在城市ID */
//@property (nonatomic ,copy) NSString *city;
//
///** 用户所在地 */
//@property (nonatomic ,copy) NSString *location;
//
///** 用户个人描述 */
//@property (nonatomic ,copy) NSString *desc;
//
//
///** 用户头像地址（中图），50×50像素 */
//@property (nonatomic ,copy) NSString *profile_image_url;
//
///** 性别，m：男、f：女、n：未知 */
//@property (nonatomic ,copy) NSString *gender;
//
///** 粉丝数 */
//@property (nonatomic ,assign) NSInteger followers_count;
//
///** 关注数 */
//@property (nonatomic ,assign) NSInteger friends_count;
//
///** 微博数 */
//@property (nonatomic ,assign) NSInteger statuses_count;
//
///** 收藏数 */
//@property (nonatomic ,assign) NSInteger favourites_count;
//
///** 用户创建（注册）时间 */
//@property (nonatomic ,copy) NSString *created_at;
//
///** 是否是微博认证用户，即加V用户，true：是，false：否 */
//@property (nonatomic ,assign) BOOL verified;
//
///** 是否允许所有人对我的微博进行评论 */
//@property (nonatomic ,assign) BOOL allow_all_comment;
//
///** 用户头像地址（大图），180×180像素 */
//@property (nonatomic ,copy) NSString *avatar_large;
//
///** 用户头像地址（高清），高清头像原图 */
//@property (nonatomic ,copy) NSString *avatar_hd;
//
///** 该用户是否关注当前登录用户，true：是，false：否 */
//@property (nonatomic ,assign) BOOL follow_me;
//
///** 用户的在线状态，0：不在线、1：在线 */
//@property (nonatomic ,assign) NSInteger online_status;
//
///** 个人中心背景图 */
//@property (nonatomic ,copy) NSString *cover_image_phone;
//
//
//+ (id)userInfoWithDict:(NSDictionary *)dict;



//@property (nonatomic ,assign) NSInteger class;
//@property (nonatomic ,assign) BOOL allow_all_act_msg;
//@property (nonatomic ,copy) NSString *remark;
//@property (nonatomic ,copy) NSString *verified_trade;
//@property (nonatomic ,assign) NSInteger mbtype;
//@property (nonatomic ,copy) NSString *verified_reason;
//@property (nonatomic ,assign) BOOL geo_enabled;
//@property (nonatomic ,copy) NSString *url; //用户博客地址
//@property (nonatomic ,assign) NSInteger bi_followers_count;
//@property (nonatomic ,copy) NSString *lang;
//@property (nonatomic ,copy) NSString *verified_source_url;
//@property (nonatomic ,assign) NSInteger credit_score;
//@property (nonatomic ,assign) NSInteger block_word;
//@property (nonatomic ,assign) BOOL following;
//@property (nonatomic ,assign) NSInteger verified_type;
//@property (nonatomic ,assign) NSInteger star;
//@property (nonatomic ,copy) NSString *domain;
///** 用户的最近一条微博信息字段 */
//@property (nonatomic ,strong) NSDictionary *status;
//@property (nonatomic ,assign) NSInteger block_app;
//@property (nonatomic ,assign) NSInteger urank;
//@property (nonatomic ,copy) NSString *verified_reason_url;
//@property (nonatomic ,copy) NSString *verified_source;
//@property (nonatomic ,copy) NSString *weihao;
//@property (nonatomic ,assign) NSInteger pagefriends_count;
//@property (nonatomic ,assign) NSInteger mbrank;
//@property (nonatomic ,copy) NSString *profile_url; //用户的微博统一URL地址
//@property (nonatomic ,assign) NSInteger user_ability;
//@property (nonatomic ,assign) NSInteger ptype;




@end
