//
//  MYZComposeController.h
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZStatusOriginal;

typedef NS_ENUM(NSUInteger, ComposeType)
{
    ComposeTypeOriginal,
    ComposeTypeRepost,
    ComposeTypeComment,
};

@interface MYZComposeController : UIViewController

/** 写微博，写评论，写转发 */
@property (nonatomic, assign) ComposeType composeType;

/** 写转发微博时候，传递过来的转发微博模型 */
@property (nonatomic, strong) MYZStatusOriginal * status;

@end
