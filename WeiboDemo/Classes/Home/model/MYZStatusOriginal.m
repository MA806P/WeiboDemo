//
//  MYZStatusOriginal.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusOriginal.h"
#import "MYZStatusRetweeted.h"
#import "MYZUserInfo.h"

@implementation MYZStatusOriginal

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSDictionary * retweetedStatusDic = value[@"retweeted_status"];
        if (retweetedStatusDic)
        {
            MYZStatusRetweeted * re = [[MYZStatusRetweeted alloc] initWithValue:retweetedStatusDic];
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
