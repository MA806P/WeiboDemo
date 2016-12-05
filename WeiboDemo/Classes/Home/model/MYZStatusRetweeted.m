//
//  MYZStatusRetweeted.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusRetweeted.h"

@implementation MYZStatusRetweeted

+ (NSString *)primaryKey
{
    return @"mid";
}

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"createdStr"];
}


@end
