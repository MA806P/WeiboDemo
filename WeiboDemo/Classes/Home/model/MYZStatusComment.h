//
//  MYZStatusComment.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZUserInfo;

@interface MYZStatusComment : NSObject

/*
"created_at":"Fri Dec 23 14:30:41 +0800 2016",
"id":4055854967846634,
"rootid":4055854967846634,
"floor_number":2,
"text":"repost",
"source_allowclick":0,
"source_type":1,
"source":"<a href="http://app.weibo.com/t/feed/6vtZb0" rel="nofollow">微博 weibo.com</a>",
"user":Object{...},
"mid":"4055854967846634",
"idstr":"4055854967846634",
"status":Object{...}
 */

/** 评论id */
@property (nonatomic, copy) NSString * mid;

/** 来源 */
@property (nonatomic, copy) NSString * source;

/** 评论时间 */
@property (nonatomic, copy) NSString * created_at;

/** 评论内容 */
@property (nonatomic, copy) NSString * text;

/** 用户信息 */
@property (nonatomic, strong) MYZUserInfo * user;


+ (id)statusCommentWithDict:(NSDictionary *)dict;
- (id)initStatusCommentWithDict:(NSDictionary *)dict;

@end
