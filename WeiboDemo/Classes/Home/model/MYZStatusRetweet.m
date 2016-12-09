//
//  MYZStatusRetweet.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/9.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusRetweet.h"
#import "MYZUserInfo.h"

@implementation MYZStatusRetweet

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSString * reText = value[@"text"];
        self.text = [NSString stringWithFormat:@"@%@ : %@",self.user.name,reText];
    }
    return self;
}


@end
