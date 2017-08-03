//
//  MYZStatusComment.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusComment.h"
#import "MYZUserInfo.h"

@implementation MYZStatusComment

- (id)initStatusCommentWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.mid = dict[@"mid"];
        
        
        NSString * sourceStr = dict[@"source"];
        if (sourceStr.length > 1)
        {
            NSUInteger location = [sourceStr rangeOfString:@">"].location + 1;
            NSUInteger length = [sourceStr rangeOfString:@"</"].location - location;
            NSString * fromStr = [sourceStr substringWithRange:NSMakeRange(location, length)];
            self.source = [NSString stringWithFormat:@"[%@]",fromStr];
        }
        else
        {
            self.source = @"";
        }
        
        //"created_at":"Fri Dec 23 14:30:41 +0800 2016"
        //Mon Jul 31 20:43:27 +0800 2017
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_CN"];
        [dateFormatter setLocale:locale];
        
        NSString * created_at_str = dict[@"created_at"];
        NSDate * createDate = [dateFormatter dateFromString:created_at_str];
        dateFormatter.dateFormat = @"MM-dd HH:mm";
        self.created_at = [NSString stringWithFormat:@"(%@)",[dateFormatter stringFromDate:createDate]];
        
        self.text = dict[@"text"];
        self.user = [[MYZUserInfo alloc] initWithValue:dict[@"user"]];
    }
    return self;
}

+ (id)statusCommentWithDict:(NSDictionary *)dict
{
    return [[MYZStatusComment alloc] initStatusCommentWithDict:dict];
}


@end
