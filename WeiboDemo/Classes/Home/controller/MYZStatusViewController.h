//
//  MYZStatusViewController.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZStatusFrame;

FOUNDATION_EXPORT CGFloat const StatusBottomH; //底部转发评论点赞栏 高度

typedef NS_ENUM(NSUInteger, StatusViewControllerType)
{
    StatusViewControllerTypeDeltail, //显示微博详情
    StatusViewControllerTypeComment //显示评论列表
};

@interface MYZStatusViewController : UITableViewController

/** 显示类型 */
@property (nonatomic, assign) StatusViewControllerType type;

/** 传递过来的微博信息 */
@property (nonatomic, strong) MYZStatusFrame * statusFrame;

@end
