//
//  MYZOAuthController.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYZAccount;

@interface MYZOAuthController : UIViewController

- (void)oauthSuccessWithAccount:(MYZAccount *)account;

@end
