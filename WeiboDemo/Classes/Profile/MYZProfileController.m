//
//  MYZProfileController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZProfileController.h"
#import "MYZOAuthController.h"
#import "WeiboSDK.h"

@implementation MYZProfileController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    //判断是否授权
    MYZAccount * account = [MYZTools account];
    if (account == nil)
    {
        [MYZTools showAlertWithText:@"用户未登录"];
        MYZOAuthController * oauthVC = [[MYZOAuthController alloc] init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:oauthVC];
        return;
    }
    
    //获取用户信息
    NSDictionary * showParameter = @{@"access_token":account.access_token,@"uid":account.uid};
    [MYZHttpTools get:@"https://api.weibo.com/2/users/show.json" parameters:showParameter progress:^(NSProgress *progress) {
    } success:^(id response) {
        NSDictionary * userInfoDic = (NSDictionary *)response;
        MYZLog(@" --- %@ ", userInfoDic);
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
    }];
    
    //用户最新发表的微博列表
    /*
     screen_name	false	string	需要查询的用户昵称。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	false	int	单页返回的记录条数，最大不超过100，超过100以100处理，默认为20。
     page	false	int	返回结果的页码，默认为1。
     base_app	false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
     feature	false	int	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
     trim_user	false	int	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
     */
    NSDictionary * userTimelineParameter = @{@"access_token":account.access_token,@"uid":account.uid};
    [MYZHttpTools get:@"https://api.weibo.com/2/statuses/user_timeline.json" parameters:userTimelineParameter progress:^(NSProgress *progress) {
    } success:^(id response) {
        NSDictionary * userTimelineDic = (NSDictionary *)response;
        MYZLog(@" --- %@ ", userTimelineDic);
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
    }];
}

- (void)logout
{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray * subPaths = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    for (NSString * subPath in subPaths)
    {
        NSString * fullSubpath = [cachPath stringByAppendingPathComponent:subPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullSubpath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:fullSubpath error:nil];
        }
    }
    
    MYZOAuthController * oauthVC = [[MYZOAuthController alloc] init];
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:oauthVC];
    
}

@end
