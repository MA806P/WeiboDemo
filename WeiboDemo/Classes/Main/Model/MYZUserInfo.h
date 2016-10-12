//
//  MYZUserInfo.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/10.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYZUserInfo : NSObject


@property (nonatomic ,assign) BOOL allow_all_comment;

@property (nonatomic ,copy) NSString *avatar_large;

@property (nonatomic ,copy) NSString *profile_image_url;

@property (nonatomic ,assign) NSInteger class;

@property (nonatomic ,assign) NSInteger id;

@property (nonatomic ,copy) NSString *created_at;

@property (nonatomic ,assign) BOOL allow_all_act_msg;

@property (nonatomic ,copy) NSString *remark;

@property (nonatomic ,copy) NSString *verified_trade;

@property (nonatomic ,assign) NSInteger mbtype;

@property (nonatomic ,copy) NSString *verified_reason;

@property (nonatomic ,copy) NSString *location;

@property (nonatomic ,assign) BOOL geo_enabled;

@property (nonatomic ,copy) NSString *idstr;

@property (nonatomic ,copy) NSString *desc;

@property (nonatomic ,copy) NSString *url;

@property (nonatomic ,assign) NSInteger followers_count;

@property (nonatomic ,assign) BOOL follow_me;

@property (nonatomic ,assign) NSInteger bi_followers_count;

@property (nonatomic ,copy) NSString *lang;

@property (nonatomic ,copy) NSString *verified_source_url;

@property (nonatomic ,assign) NSInteger credit_score;

@property (nonatomic ,assign) NSInteger block_word;

@property (nonatomic ,assign) NSInteger statuses_count;

@property (nonatomic ,assign) BOOL following;

@property (nonatomic ,assign) NSInteger verified_type;

@property (nonatomic ,copy) NSString *avatar_hd;

@property (nonatomic ,copy) NSString *cover_image_phone;

@property (nonatomic ,assign) NSInteger star;

@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,copy) NSString *domain;

@property (nonatomic ,copy) NSString *city;

/** 用户的最近一条微博信息字段 */
@property (nonatomic ,strong) NSDictionary *status;

@property (nonatomic ,assign) NSInteger online_status;

@property (nonatomic ,assign) NSInteger block_app;

@property (nonatomic ,assign) NSInteger urank;

@property (nonatomic ,copy) NSString *verified_reason_url;

@property (nonatomic ,copy) NSString *screen_name;

@property (nonatomic ,copy) NSString *province;

@property (nonatomic ,copy) NSString *verified_source;

@property (nonatomic ,copy) NSString *weihao;

@property (nonatomic ,copy) NSString *gender;

@property (nonatomic ,assign) NSInteger pagefriends_count;

@property (nonatomic ,assign) NSInteger favourites_count;

@property (nonatomic ,assign) NSInteger mbrank;

@property (nonatomic ,copy) NSString *profile_url;

@property (nonatomic ,assign) NSInteger user_ability;

@property (nonatomic ,assign) NSInteger ptype;

@property (nonatomic ,assign) NSInteger friends_count;

@property (nonatomic ,assign) BOOL verified;



@end
