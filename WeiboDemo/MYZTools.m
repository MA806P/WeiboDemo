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

@implementation MYZTools


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


@end
