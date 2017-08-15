//
//  MYZDynamicItem.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 17/8/15.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYZDynamicItem : NSObject

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGAffineTransform transform;
@property (nonatomic, assign, readonly) CGRect bounds;

@end
