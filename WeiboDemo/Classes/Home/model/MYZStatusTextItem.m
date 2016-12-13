//
//  MYZStatusTextItem.m
//  WeiboDemo
//
//  Created by MA806P on 2016/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusTextItem.h"

@implementation MYZStatusTextItem

- (NSString *)description
{
    return [NSString stringWithFormat:@" -- %@ %@ %@", NSStringFromRange(self.range), self.text, self.rects];
}

@end
