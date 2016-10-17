//
//  MYZStatus.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatus.h"
#import "MYZUserInfo.h"

@implementation MYZStatus

+ (NSDictionary *)linkingObjectsProperties {
    return @{@"MYZStatus":@"retweeted_status", @"MYZUserInfo":@"user"};
}

+ (NSString *)primaryKey {
    return @"mid";
}


@end
