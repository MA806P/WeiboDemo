//
//  MYZStatusRetweeted.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/17.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusRetweeted.h"
#import "MYZUserInfo.h"

@implementation MYZStatusRetweeted

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
