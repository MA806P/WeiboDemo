//
//  NSString+MYZ.m
//  CategoryProject
//
//  Created by 159CaiMini02 on 16/7/5.
//  Copyright © 2016年 myz. All rights reserved.
//

#import "NSString+MYZ.h"

#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MYZ)


- (CGSize)myz_stringSizeWithMaxSize:(CGSize)maxSize andFont:(UIFont *)font
{
    
//        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineBreakMode = self.lineBreakMode;
//        paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{
                                  NSFontAttributeName : font
                                  //,NSParagraphStyleAttributeName : paragraphStyle
                                  //NSForegroundColorAttributeName
                                  };
    
    CGSize contentSize = [self boundingRectWithSize:maxSize
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil].size;
    return contentSize;
}



+ (NSString *)myz_stringGetWeekdayFromDate:(NSString *)dateString
{
    // "1970-01-01 23:50:00",
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    //真机上需要设置区域，才能正确获取本地日期 zh_CN NSCalendarIdentifierChinese
//    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday fromDate:date];
    
    
//    NSInteger month = [components month];
//    NSInteger day= [components day];
//    NSInteger hour = [components hour];
//    NSInteger minute = [components minute];
    
    NSInteger week = components.weekday;
    NSString *weekStr = @"";
    if(week==1){
        weekStr=@"周日";
    }
    else if(week==2){
        weekStr=@"周一";
    }
    else if(week==3){
        weekStr=@"周二";
    }
    else if(week==4){
        weekStr=@"周三";
    }
    else if(week==5){
        weekStr=@"周四";
    }
    else if(week==6){
        weekStr=@"周五";
    }
    else if(week==7){
        weekStr=@"周六";
    }
    
    
    return weekStr;
}




+ (NSString*)myz_stringMD5WithInput:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), result);
    
    NSMutableString * resultStr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [resultStr appendFormat:@"%02x",result[i]];
    }
    //NSLog(@" %@ ", resultStr);
    
    return resultStr;
}




+ (NSString *)myz_stringGetHomeDirectory
{
    return NSHomeDirectory();
}


+ (NSString *)myz_stringGetDocumentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}


+ (NSString *)myz_stringGetCachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}


+ (NSString *)myz_stringGetTemporaryDirectory
{
    return NSTemporaryDirectory();
}


- (float)myz_getFilePathSize
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self]) { return 0; }
    
    unsigned long long sumSize = 0;
    NSDictionary * attributeDic = [fileManager attributesOfItemAtPath:self error:nil];
    NSString * fileType = attributeDic.fileType;
    
    //判断所给的路径是文件夹 还是文件
    if ([fileType isEqualToString:NSFileTypeDirectory])
    {
        //文件夹下的所有子文件路径, 包括文件夹套文件夹
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:self];
        for (NSString *subpath in enumerator)
        {
            NSString * fullSubpath = [self stringByAppendingPathComponent:subpath];
            unsigned long long subFileSize = [fileManager fileExistsAtPath:fullSubpath]?[[fileManager attributesOfItemAtPath:fullSubpath error:nil] fileSize]:0;
            sumSize += subFileSize;
            //NSLog(@"%@ %lld %lld", subpath, subFileSize, sumSize);
        }
    }
    else
    {
        sumSize = attributeDic.fileSize;
    }
    
    return sumSize/(1024.0*1024.0);
}
//- (void)clearCache
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        
//        NSArray * subPaths = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//        //NSLog(@"files :%@",subPaths);
//        for (NSString * subPath in subPaths)
//        {
//            NSString * fullSubpath = [cachPath stringByAppendingPathComponent:subPath];
//            if ([[NSFileManager defaultManager] fileExistsAtPath:fullSubpath])
//            {
//                [[NSFileManager defaultManager] removeItemAtPath:fullSubpath error:nil];
//            }
//        }
//        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
//    });
//}
//-(void)clearCacheSuccess
//{
//    NSLog(@"清理成功");
//}



@end
