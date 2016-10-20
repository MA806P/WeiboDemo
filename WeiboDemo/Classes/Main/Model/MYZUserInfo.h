//
//  MYZUserInfo.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/10.
//  Copyright © 2016年 MA806P. All rights reserved.
//



/*
 {
 "allow_all_act_msg" = 0;
 "allow_all_comment" = 1;
 "avatar_hd" = "http://tva1.sinaimg.cn/crop.142.142.355.355.1024/00696P6Fjw8f7jsgl0t2kj30hs0hsmyg.jpg";
 "avatar_large" = "http://tva1.sinaimg.cn/crop.142.142.355.355.180/00696P6Fjw8f7jsgl0t2kj30hs0hsmyg.jpg";
 "bi_followers_count" = 0;
 "block_app" = 0;
 "block_word" = 0;
 city = 1000;
 class = 1;
 "cover_image_phone" = "http://ww3.sinaimg.cn/crop.0.0.0.640.640/6ce2240djw1e9uwupbjn7j20hs0hstc2.jpg";
 "created_at" = "Sat Jun 13 15:03:36 +0800 2015";
 "credit_score" = 80;
 description = "\U90a3\U4e00\U5929, \U5929\U5f88\U84dd, \U4e91\U5f88\U8f7b .";
 domain = "";
 "favourites_count" = 229;
 "follow_me" = 0;
 "followers_count" = 1;
 following = 0;
 "friends_count" = 64;
 gender = m;
 "geo_enabled" = 1;
 id = 5631410441;
 idstr = 5631410441;
 lang = "zh-cn";
 location = "\U5176\U4ed6";
 mbrank = 0;
 mbtype = 0;
 name = "YU\U590f\U7684\U6545\U4e8b";
 "online_status" = 0;
 "pagefriends_count" = 0;
 "profile_image_url" = "http://tva1.sinaimg.cn/crop.142.142.355.355.50/00696P6Fjw8f7jsgl0t2kj30hs0hsmyg.jpg";
 "profile_url" = "u/5631410441";
 province = 100;
 ptype = 0;
 remark = "";
 "screen_name" = "YU\U590f\U7684\U6545\U4e8b";
 star = 0;
 status =     { annotations = (  { "mapi_request" = 1; } ); "attitudes_count" = 0; "biz_feature" = 0; "comments_count" = 0;
        "created_at" = "Tue Oct 18 23:46:16 +0800 2016";
        "darwin_tags" =         ( );
        favorited = 0;
        geo = "<null>";
        "gif_ids" = "";
        hasActionTypeCard = 0;
        "hot_weibo_tags" =         ();
        id = 4032077189823898;
        idstr = 4032077189823898;
        "in_reply_to_screen_name" = "";
        "in_reply_to_status_id" = "";
 
        "in_reply_to_user_id" = "";
        isLongText = 0;
        "is_show_bulletin" = 2;
        mid = 4032077189823898;
        mlevel = 0;
        "pic_urls" =         ( );
        "positive_recom_flag" = 0;
        "reposts_count" = 0;
        source = "<a href=\"http://app.weibo.com/t/feed/3jskmg\" rel=\"nofollow\">iPhone 6s</a>";
        "source_allowclick" = 0;
        "source_type" = 1;
        text = "\U633a\U597d\U7684";
        "text_tag_tips" =         ( );
        truncated = 0;
        userType = 0;
        visible = { "list_id" = 0; type = 0; };
 };
 "statuses_count" = 31;
 urank = 5;
 url = "";
 "user_ability" = 0;
 verified = 0;
 "verified_reason" = "";
 "verified_reason_url" = "";
 "verified_source" = "";
 "verified_source_url" = "";
 "verified_trade" = "";
 "verified_type" = "-1";
 weihao = "";
 }
 
 
 */



#import <Foundation/Foundation.h>

@interface MYZUserInfo : RLMObject



/** 字符串型的用户UID */
@property NSString *idstr;

///** 用户昵称 */
//@property NSString *screen_name;

/** 友好显示名称 */
@property NSString *name;

///** 用户所在省级ID */
//@property NSString *province;
///** 用户所在城市ID */
//@property NSString *city;

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
/** 认证类型 -1 未认证, 0个人认证, >=2企业认证 */
@property NSInteger verified_type;
/** 认证信息 */
@property NSString *verified_reason;


/** 会员类型 0(个人) 2(企业)不是会员, 11(个人) 12(企业) 是会员 >2 的是会员 */
@property NSInteger mbtype;
/** 是否是会员 */
@property BOOL isVip;
///** 会员等级 */
//@property NSInteger mbrank;

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






//@property (nonatomic ,assign) NSInteger class;
//@property (nonatomic ,assign) BOOL allow_all_act_msg;
//@property (nonatomic ,copy) NSString *remark;
//@property (nonatomic ,copy) NSString *verified_trade;

//@property (nonatomic ,assign) BOOL geo_enabled;
//@property (nonatomic ,copy) NSString *url; //用户博客地址
//@property (nonatomic ,assign) NSInteger bi_followers_count;
//@property (nonatomic ,copy) NSString *lang;
//@property (nonatomic ,copy) NSString *verified_source_url;
//@property (nonatomic ,assign) NSInteger credit_score;
//@property (nonatomic ,assign) NSInteger block_word;
//@property (nonatomic ,assign) BOOL following;

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
//@property (nonatomic ,copy) NSString *profile_url; //用户的微博统一URL地址
//@property (nonatomic ,assign) NSInteger user_ability;









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







@end
