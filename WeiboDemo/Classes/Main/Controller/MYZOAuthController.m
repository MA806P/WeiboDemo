//
//  MYZOAuthController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZOAuthController.h"
#import "MYZTabBarController.h"
#import "MYZAccount.h"
#import "MYZUserInfo.h"

@interface MYZOAuthController ()

@end

@implementation MYZOAuthController

- (void)loadView
{
    UIImageView * oauthBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"oauth_bg"]];
    oauthBgView.userInteractionEnabled = YES;
    self.view = oauthBgView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat btnW = 200;
    CGFloat btnH = 40;
    CGFloat btnX = (SCREEN_W - btnW) * 0.5;
    CGFloat btnY = SCREEN_H - 100;
    
    UIImage * bgImage = [UIImage imageNamed:@"oauth_login_bg"];
    UIImage * bgHighImage = [UIImage imageNamed:@"oauth_login_bg_highlighted"];
    UIButton * loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    [loginBtn setTitle:@"微博账号登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.5 topCapHeight:bgImage.size.height*0.5] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[bgHighImage stretchableImageWithLeftCapWidth:bgHighImage.size.width*0.5 topCapHeight:bgHighImage.size.height*0.5] forState:UIControlStateHighlighted];
    
    [loginBtn addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
}

- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"friendships_groups_read,friendships_groups_write,statuses_to_me_read,follow_app_official_microblog";
    request.userInfo = @{@"SSO_From": @"MYZOAuth", @"APP_ID":@"MYZ"};
    [WeiboSDK sendRequest:request];
}


- (void)oauthSuccessWithAccount:(MYZAccount *)account
{
    MYZLog(@"--- %@ %@ ", account.access_token, account.uid);
    if(account == nil) { return; }
    
    
    [SVProgressHUD show];
    
    NSDictionary * parameter = @{@"access_token":account.access_token, @"uid":account.uid};
    [MYZHttpTools get:@"https://api.weibo.com/2/users/show.json" parameters:parameter progress:nil success:^(id response) {
        
//        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:response];
//        [dic setObject:dic[@"description"] forKey:@"desc"];
//        [dic removeObjectForKey:@"description"];
        
        MYZUserInfo * userInfo = [[MYZUserInfo alloc] initWithValue:response];
        [MYZTools saveUserInfo:userInfo];
        
        //设置主控制器，显示主页面
        MYZTabBarController * tabBarController = [[MYZTabBarController alloc] init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabBarController];
        
        MYZLog(@"--- %@ ", userInfo);
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        MYZLog(@"--- %@", error);
        [SVProgressHUD dismiss];
    }];
    
    
    //进入主界面
//    MYZTabBarController * tabBarController = [[MYZTabBarController alloc] init];
//    self.window.rootViewController = tabBarController;
    
}


@end
