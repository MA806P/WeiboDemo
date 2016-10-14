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
    [realm addObject:userInfo];
    [realm commitWriteTransaction];
}





@end
