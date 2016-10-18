//
//  MYZTools.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYZAccount, MYZUserInfo;

@interface MYZTools : NSObject

+ (MYZAccount *)account;
+ (void)saveAccount:(MYZAccount *)account;

+ (MYZUserInfo *)userInfo;
+ (void)saveUserInfo:(MYZUserInfo *)userInfo;


+ (void)showAlertWithText:(NSString *)text;

@end
