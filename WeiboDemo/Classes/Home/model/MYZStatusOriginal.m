//
//  MYZStatusOriginal.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusOriginal.h"
#import "MYZStatusRetweeted.h"

@implementation MYZStatusOriginal

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSDictionary * retweetedStatusDic = value[@"retweeted_status"];
        if (retweetedStatusDic)
        {
            self.retweeted_status = [[MYZStatusRetweeted alloc] initWithValue:retweetedStatusDic];
        }
        
    }
    return self;
}

+ (NSString *)primaryKey
{
    return @"mid";
}

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"createdStr"];
}


@end
