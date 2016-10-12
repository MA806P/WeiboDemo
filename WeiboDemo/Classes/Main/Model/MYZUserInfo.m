//
//  MYZUserInfo.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/10.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZUserInfo.h"

@implementation MYZUserInfo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"desc" : @"desciption"};
    
    //    return @{@"ID" : @"id",
    //             @"desc" : @"desciption",
    //             @"oldName" : @"name.oldName",
    //             @"nowName" : @"name.newName",
    //             @"nameChangedTime" : @"name.info[1].nameChangedTime",
    //             @"bag" : @"other.bag"
    //             };
    
}

@end
