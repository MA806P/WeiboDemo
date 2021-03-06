//
//  MYZHttpTools.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZHttpTools.h"
#import "AFNetworking.h"

@implementation MYZHttpTools

+ (void)get:(NSString *)urlStr parameters:(NSDictionary *)parameter progress:(void (^)(NSProgress *progress))progress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    //链接拼接
    NSMutableString * urlParamString = [NSMutableString stringWithFormat:@"%@?",urlStr];
    [parameter enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [urlParamString appendFormat:@"%@=%@&",key,obj];
    }];
    if ([urlParamString hasSuffix:@"&"]||[urlParamString hasSuffix:@"?"])
    {
        [urlParamString deleteCharactersInRange:NSMakeRange(urlParamString.length-1, 1)];
    }
    MYZLog(@"get +++ %@", urlParamString);

    
    AFHTTPSessionManager * httpMannager = [AFHTTPSessionManager manager];
    
    [httpMannager GET:urlStr parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress != nil) { progress(downloadProgress); }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
    
}

+ (void)post:(NSString *)urlStr parameters:(NSDictionary *)parameter progress:(void (^)(NSProgress *progress))progress success:(void (^)(id response))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager * httpMannager = [AFHTTPSessionManager manager];
    
    [httpMannager POST:urlStr parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress != nil) { progress(uploadProgress); }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
