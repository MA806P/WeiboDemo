//
//  MYZUserInfo.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/10.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZUserInfo.h"


@implementation MYZUserInfo

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        //NSLog(@"---  %@ ",value);
        self.desc = value[@"description"];
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"idstr";
}






//+ (id)userInfoWithDict:(NSDictionary *)dict
//{
//    MYZUserInfo * userInfo = [[self alloc] init];
//    userInfo.idstr = dict[@""];
//    userInfo.screen_name = dict[@"screen_name"];
//    userInfo.name = dict[@"name"];
//    userInfo.province = dict[@"province"];
//    userInfo.city = dict[@"city"];
//    userInfo.location = dict[@"location"];
//    userInfo.desc = dict[@"description"];
//    userInfo.profile_image_url = dict[@"profile_image_url"];
//    userInfo.gender = dict[@"gender"];
//    userInfo.followers_count = [dict[@"followers_count"] integerValue];
//    userInfo.friends_count = [dict[@"friends_count"] integerValue];
//    userInfo.statuses_count = [dict[@"statuses_count"] integerValue];
//    userInfo.favourites_count = [dict[@"favourites_count"] integerValue];
//    userInfo.created_at = dict[@"created_at"];
//    userInfo.allow_all_comment = [dict[@"allow_all_comment"] boolValue];
//    userInfo.avatar_large = dict[@"avatar_large"];
//    userInfo.avatar_hd = dict[@"avatar_hd"];
//    userInfo.follow_me = [dict[@"follow_me"] boolValue];
//    userInfo.online_status = [dict[@"online_status"] integerValue];
//    userInfo.verified = [dict[@"verified"] boolValue];
//    userInfo.cover_image_phone = dict[@"cover_image_phone"];
//    
//    return userInfo;
//}

@end
