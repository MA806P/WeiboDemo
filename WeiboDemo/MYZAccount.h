//
//  MYZAccount.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/10.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYZAccount : NSObject


/** string 	用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString *access_token;

/** string 	access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSString *expires_in;

/** 过期时间 */
@property (nonatomic, strong) NSDate *expires_time;

/** string 	当前授权用户的UID。*/
@property (nonatomic, copy) NSString *uid;


+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
