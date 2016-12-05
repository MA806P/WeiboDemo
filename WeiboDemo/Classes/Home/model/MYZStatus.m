//
//  MYZStatus.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatus.h"
#import "MYZUserInfo.h"
#import "RegexKitLite.h"
#import "MYZStatusTextItem.h"

@implementation MYZStatus


- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSDictionary * userDic = value[@"user"];
        
        if (userDic)
        {
            self.user = [[MYZUserInfo alloc] initWithValue:userDic];
        }
        
        //来源, 这个不像时间是不变的所以直接存储就行了
        //不用重写getter方法不用每次都调用
        NSString * sourceStr = value[@"source"];
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
        
        //处理微博正文，富文本
        NSString * text = value[@"text"];
        self.attributedText = [self regexResultsWithText:text];
        
    }
    return self;
}


//+ (NSDictionary *)linkingObjectsProperties {
//    return @{@"MYZStatusRetweeted":@"retweeted_status", @"MYZUserInfo":@"user"};
//}

+ (NSString *)primaryKey
{
    return @"mid";
}

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"createdStr", @"attributedText"];
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
//                _createdStr = [NSString stringWithFormat:@"%ld小时前", fromNowComp.hour];
//            }
//            else if (fromNowComp.minute >= 1)
//            {
//                _createdStr = [NSString stringWithFormat:@"%ld分钟前", fromNowComp.minute];
//            }
//            else
//            {
//                _createdStr = @"刚刚";
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
    //MYZLog(@" MYZStatus createStr --- %@  %@ ", createDate , _createdStr);
    return _createdStr;
}


//处理微博内容，处理字符串，显示不同的格式，@、##、连接、、
- (NSAttributedString *)regexResultsWithText:(NSString *)text
{
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] init];
    
    //使用过正则表达式进行匹配信息
    //匹配后被截为各个小段，放到数组中保存
    NSMutableArray * textItems = [NSMutableArray array];
    
    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.range = *capturedRanges;
        
        [textItems addObject:textItem];
    }];
    
    // 匹配#话题#
    NSString *topicRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
    [text enumerateStringsMatchedByRegex:topicRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.range = *capturedRanges;
        
        [textItems addObject:textItem];
    }];
    
    // 匹配@...
    NSString *userRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-]+ ?";
    [text enumerateStringsMatchedByRegex:userRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.range = *capturedRanges;
        
        [textItems addObject:textItem];
    }];
    
    // 匹配超链接
    NSString *urlRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
    [text enumerateStringsMatchedByRegex:urlRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        MYZStatusTextItem * textItem = [[MYZStatusTextItem alloc] init];
        textItem.range = *capturedRanges;
        
        [textItems addObject:textItem];
    }];
    
    
    //被截成的小段进行排序
    [textItems sortUsingComparator:^NSComparisonResult(MYZStatusTextItem * obj1, MYZStatusTextItem * obj2) {
        NSUInteger loc1 = obj1.range.location;
        NSUInteger loc2 = obj2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    
    //遍历各个小段
    
    return attributedText;
}


@end
