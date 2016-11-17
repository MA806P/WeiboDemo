//
//  MYZStatusTool.m
//  WeiboDemo
//
//  Created by MA806P on 2016/11/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusTool.h"
#import "AFNetworking.h"

@implementation MYZStatusTool


//转发一条微博
+ (void)sendStatusRepostWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    [MYZHttpTools post:@"https://api.weibo.com/2/statuses/repost.json" parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//发布一条微博
+ (void)sendStatusUpdateWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    [MYZHttpTools post:@"https://api.weibo.com/2/statuses/update.json" parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//上传图片并发布一条新微博
+ (void)sendStatusUploadWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
//    [MYZHttpTools post:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:param progress:^(NSProgress *progress) {
//        
//    } success:^(id response) {
//        success(response);
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
    

    
    
    AFHTTPSessionManager * httpMannager = [AFHTTPSessionManager manager];
    
    [httpMannager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:param[@"pic"] name:@"pic" fileName:@"" mimeType:@"image/pjpeg"];;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//指定一个图片URL地址抓取后上传并同时发布一条新微博
+ (void)sendStatusUploadUrlTextWithParam:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    
    [MYZHttpTools post:@"https://api.weibo.com/2/statuses/upload_url_text.json" parameters:param progress:^(NSProgress *progress) {
        
    } success:^(id response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
