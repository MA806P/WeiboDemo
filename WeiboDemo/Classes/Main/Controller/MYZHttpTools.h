//
//  MYZHttpTools.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYZHttpTools : NSObject

/**
 *  网络请求, GET请求
 *  @param url     请求链接地址
 *  @param params  请求参数
 *  @param success 成功
 *  @param failure 失败  nullable _Nullable
 */
+ (void)get:(NSString *)urlStr parameters:(NSDictionary *)parameter progress:(void (^)(NSProgress *progress))progress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 *  网络请求, post请求
 *  @param url     请求链接地址
 *  @param params  请求参数
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)post:(NSString *)urlStr parameters:(NSDictionary *)parameter progress:(void (^)(NSProgress *progress))progress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

@end
