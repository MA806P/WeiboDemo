//
//  MYZTools.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//


#define MYZAccountFilepath [MYZFileRootPath stringByAppendingPathComponent:@"account.data"]

#import "MYZTools.h"
#import "MYZAccount.h"
#import "MYZUserInfo.h"

@implementation MYZTools


#pragma mark - 账号授权信息

+ (MYZAccount *)account
{
    //获取缓存的账号认证信息
    MYZAccount * account = [NSKeyedUnarchiver unarchiveObjectWithFile:MYZAccountFilepath];
    
    //判断账号授权是否过期
    BOOL outDate = [[NSDate date] compare:account.expires_time] != NSOrderedAscending;
    //MYZLog(@" %@ --- %@  %d", [NSDate date], account.expires_time, outDate);
    
    if (outDate)
    {
        account = nil;
    }
    
    return account;
}

+ (void)saveAccount:(MYZAccount *)account
{
    //归档
    [NSKeyedArchiver archiveRootObject:account toFile:MYZAccountFilepath];
}


#pragma mark - 用户信息

+ (MYZUserInfo *)userInfo
{
    MYZAccount * account = [self account];
    NSString * uid = account.uid;
    if (account == nil || uid == nil) { return nil; }
    
    RLMResults<MYZUserInfo *> *userInfo = [MYZUserInfo objectsWhere:@"idstr = %@",uid];
    return (MYZUserInfo *)userInfo;
}


+ (void)saveUserInfo:(MYZUserInfo * _Nonnull)userInfo
{
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:userInfo];
    [realm commitWriteTransaction];
}



// 添加提示信息，几秒钟后自动消失
+ (void)showAlertWithText:(NSString *)text
{
    UIFont * font =[UIFont systemFontOfSize:14];
    
    UILabel * label=[[UILabel alloc] init];
    // label.backgroundColor=[UIColor colorWithWhite:0.377 alpha:0.300];
    label.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    label.textColor = [UIColor whiteColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.font=font;
    label.layer.cornerRadius=10;
    label.clipsToBounds=YES;
    label.alpha=0;
    
    label.frame = CGRectMake(0, 0, [text sizeWithAttributes:@{NSFontAttributeName:font}].width+60, 40);
    label.center=CGPointMake(SCREEN_W*0.5, SCREEN_H*0.4);
    
    UIWindow * window=[[UIApplication sharedApplication] keyWindow];
    [window addSubview:label];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        label.alpha=1;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            label.alpha=0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
        
    }];
}



@end
