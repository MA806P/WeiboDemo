//
//  MYZStatus.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatus.h"
#import "MYZUserInfo.h"
#import "MYZStatusRetweeted.h"

@implementation MYZStatus


- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSDictionary * userDic = value[@"user"];
        NSDictionary * retweetedStatusDic = value[@"retweeted_status"];
        
        if (userDic)
        {
            self.user = [[MYZUserInfo alloc] initWithValue:userDic];
        }
        
        if (retweetedStatusDic)
        {
            self.retweeted_status = [[MYZStatusRetweeted alloc] initWithValue:retweetedStatusDic];
        }
    }
    return self;
}


//+ (NSDictionary *)linkingObjectsProperties {
//    return @{@"MYZStatusRetweeted":@"retweeted_status", @"MYZUserInfo":@"user"};
//}

+ (NSString *)primaryKey {
    return @"mid";
}


@end
