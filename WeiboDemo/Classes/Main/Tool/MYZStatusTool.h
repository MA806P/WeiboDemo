//
//  MYZStatusTool.h
//  WeiboDemo
//
//  Created by MA806P on 2016/11/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYZStatusTool : UIButton


/**
 *  转发一条微博
 *
 *  @param param   请求参数
 *  access_token    false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  id              true	int64	要转发的微博ID。
 *  status	        true	string	添加的转发文本，必须做URLencode，内容不超过140个汉字，不填则默认为“转发微博”。
 *  is_comment      false	int	是否在转发的同时发表评论，0：否、1：评论给当前微博、2：评论给原微博、3：都评论，默认为0 。
 *
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)sendStatusRepostWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;



/**
 *  指定多个图片URL地址抓取后上传并同时发布一条新微博
 *
 *  @param param   请求参数
 *  access_token    false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  status	        true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 *  visible	        false	int	微博的可见性，0：所有人能看，1：仅自己可见，2：密友可见，3：指定分组可见，默认为0。
 *  list_id	        false	string	微博的保护投递指定分组ID，只有当visible参数为3时生效且必选。
 *  url             false	string	图片的URL地址，必须以http开头。
 *  pic_id          false	string	已经上传的图片pid，多个时使用英文半角逗号符分隔，最多不超过9个。
 *  lat             false	float	纬度，有效范围：-90.0到+90.0，+表示北纬，默认为0.0。
 *  long            false	float	经度，有效范围：-180.0到+180.0，+表示东经，默认为0.0。
 *
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
//+ (void)sendStatusUploadUrlTextWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


/**
 *  发送微博，只有文字，或者带有一张图片
 */
+ (void)sendStatusWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


/**
 *  查看微博详情
 *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 *  id	true	int64	需要跳转的微博ID。
 */
+ (void)getStatusDetailWithParam:(NSDictionary *)param success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;



@end
