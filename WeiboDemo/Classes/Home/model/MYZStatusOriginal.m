//
//  MYZStatusOriginal.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusOriginal.h"
#import "MYZStatusRetweeted.h"
#import "MYZUserInfo.h"

@implementation MYZStatusOriginal

- (instancetype)initWithValue:(id)value
{
    if (self = [super initWithValue:value])
    {
        NSDictionary * retweetedStatusDic = value[@"retweeted_status"];
        if (retweetedStatusDic)
        {
            MYZStatusRetweeted * re = [[MYZStatusRetweeted alloc] initWithValue:retweetedStatusDic];
            
            NSString * reText = retweetedStatusDic[@"text"];
            re.text = [NSString stringWithFormat:@"@%@: %@",re.user.name,reText];
            
            self.retweeted_status = re;
        }
        
    }
    return self;
}



@end
