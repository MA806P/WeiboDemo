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
            self.source = [sourceStr substringWithRange:NSMakeRange(location, length)];
        }
        else
        {
            self.source = @"";
        }
        
        //"created_at":"Fri Dec 23 14:30:41 +0800 2016"
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
        NSDate * createDate = [dateFormatter dateFromString:dict[@"created_at"]];
        dateFormatter.dateFormat = @"MM-dd HH:mm";
        self.created_at =  [dateFormatter stringFromDate:createDate];
        
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
