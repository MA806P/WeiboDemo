//
//  MYZStatusCell.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/19.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>



@class MYZStatusFrame;

@interface MYZStatusCell : UITableViewCell

/** 微博数据,包括微博内容和各个空间的frame */
@property (nonatomic, strong) MYZStatusFrame * statusFrame;


@end
