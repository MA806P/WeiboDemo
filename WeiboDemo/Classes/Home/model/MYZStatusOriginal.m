//
//  MYZStatusOriginal.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusOriginal.h"
#import "MYZStatusRetweet.h"
#import "MYZUserInfo.h"

@implementation MYZStatusOriginal

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSDictionary * retweetedStatusDic = value[@"retweeted_status"];
        if (retweetedStatusDic)
        {
            MYZStatusRetweet * re = [[MYZStatusRetweet alloc] initWithValue:retweetedStatusDic];
            self.retweeted_status = re;
        }
        
    }
    return self;
}

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"createdStr", @"attributedText", @"reAttributedText"];
}




@end
