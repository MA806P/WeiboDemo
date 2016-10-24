//
//  MYZMenuView.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/21.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat const ActivityMenuHeight;
FOUNDATION_EXPORT NSInteger const ActitvityMenuShowCount;

@interface MYZMenuView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
