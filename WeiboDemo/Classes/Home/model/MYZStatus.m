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
        
        
//        //来源
//        NSString * sourceStr = value[@"source"];
//        NSUInteger location = [sourceStr rangeOfString:@">"].location + 1;
//        NSUInteger length = [sourceStr rangeOfString:@"</"].location - location;
//        self.source = [sourceStr substringWithRange:NSMakeRange(location, length)];

        
    }
    return self;
}


//+ (NSDictionary *)linkingObjectsProperties {
//    return @{@"MYZStatusRetweeted":@"retweeted_status", @"MYZUserInfo":@"user"};
//}

+ (NSString *)primaryKey {
    return @"mid";
}

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"createdStr", @"sourceStr"];
}


#pragma mark - 数据处理

//微博发布时间, 重写getter方法, 返回处理过的时间
- (NSString *)createdStr
{
    //Tue Oct 18 16:24:19 +0800 2016
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate * createDate = [dateFormatter dateFromString:self.created_at];
    NSDate * nowDate = [NSDate date];
    NSCalendar * calendar = [NSCalendar currentCalendar];
    int units = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //当前时间
    NSDateComponents * nowComponents = [calendar components:units fromDate:nowDate];
    //创建微博时间
    NSDateComponents * createComponents = [calendar components:units fromDate:createDate];
    
    //是否同一年
    if (nowComponents.year == createComponents.year)
    {
        //是否同一天
        if(nowComponents.month == createComponents.month && nowComponents.day == createComponents.day)
        {
//            NSDateComponents * fromNowComp = [calendar components:units fromDate:createDate toDate:nowDate options:0];
//            if (fromNowComp.hour >= 1)
//            {
//                return [NSString stringWithFormat:@"%ld小时前", fromNowComp.hour];
//            }
//            else if (fromNowComp.minute >= 1)
//            {
//                return [NSString stringWithFormat:@"%ld分钟前", fromNowComp.minute];
//            }
//            else
//            {
//                return @"刚刚";
//            }
            
            dateFormatter.dateFormat = @"HH:mm";
            _createdStr = [dateFormatter stringFromDate:createDate];
        }
        else
        {
            dateFormatter.dateFormat = @"MM-dd HH:mm";
            _createdStr =  [dateFormatter stringFromDate:createDate];
        }
    }
    else
    {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        _createdStr =  [dateFormatter stringFromDate:createDate];
    }
    
    return _createdStr;
}

//微博来源重写getter方法, 返回处理过的来源信息
- (NSString *)sourceStr
{
    if (self.source.length > 1)
    {
        NSUInteger location = [self.source rangeOfString:@">"].location + 1;
        NSUInteger length = [self.source rangeOfString:@"</"].location - location;
        
        return [self.source substringWithRange:NSMakeRange(location, length)];
    }
    else
    {
        return @"";
    }
    
}


@end
