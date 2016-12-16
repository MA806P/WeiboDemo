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


////指定多个图片URL地址抓取后上传并同时发布一条新微博
//+ (void)sendStatusUploadUrlTextWithParam:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure
//{
//    [MYZHttpTools post:@"https://api.weibo.com/2/statuses/upload_url_text.json" parameters:param progress:^(NSProgress *progress) {
//        
//    } success:^(id response) {
//        success(response);
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
//}




+ (void)sendStatusWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure
{
    
    
    /**
     *  发布一条新微博
     *
     *  @param param   请求参数
     *  access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     *  status          true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     *  visible         false	int	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
     *  lat             false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
     *  long            false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
     *
     *  @param success 请求成功后的回调
     *  @param failure 请求失败后的回调
     */
    //- (void)sendStatusUpdateWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
    
    
    /**
     *  上传图片并发布一条新微博
     *
     *  @param param   请求参数
     *  access_token    false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     *  status	        true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     *  visible	        false	int	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
     *  list_id	        false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
     *  pic             true	binary	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
     *  lat             false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
     *  long            false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
     *
     *  @param success 请求成功后的回调
     *  @param failure 请求失败后的回调
     */
    //- (void)sendStatusUploadWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;

    
    if (param[@"pic"] == nil)
    {
        [MYZHttpTools post:@"https://api.weibo.com/2/statuses/update.json" parameters:param progress:^(NSProgress *progress) {
            
        } success:^(id response) {
            if (success) { success(response); }
        } failure:^(NSError *error) {
            if (failure) { failure(error); }
        }];
    }
    else
    {
        AFHTTPSessionManager * httpMannager = [AFHTTPSessionManager manager];
        
        [httpMannager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:param[@"pic"] name:@"pic" fileName:@"" mimeType:@"image/pjpeg"];;
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) { success(responseObject);}
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) { failure(error); }
        }];
    }
}

+ (void)getStatusDetailWithParam:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
//    [MYZHttpTools get:@"https://api.weibo.com/2/statuses/show.json" parameters:param progress:^(NSProgress *progress) {
//        
//    } success:^(id response) {
//        success(response);
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
    
    
    AFHTTPSessionManager * httpMannager = [AFHTTPSessionManager manager];
    httpMannager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpMannager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    httpMannager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    
    [httpMannager GET:@"https://api.weibo.com/2/statuses/show.json" parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}



@end
