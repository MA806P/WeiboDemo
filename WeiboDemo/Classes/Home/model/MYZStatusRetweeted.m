//
//  MYZStatusRetweeted.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusRetweeted.h"
#import "MYZUserInfo.h"

@implementation MYZStatusRetweeted

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSDictionary * userDic = value[@"user"];
        
        if (userDic)
        {
            self.user = [[MYZUserInfo alloc] initWithValue:userDic];
        }
    }
    return self;
}

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"retweeted_status"];
}



@end
