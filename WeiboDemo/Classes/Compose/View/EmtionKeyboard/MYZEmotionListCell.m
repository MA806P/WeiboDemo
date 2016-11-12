//
//  MYZEmotionListCell.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/11/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionListCell.h"

@interface MYZEmotionListCell ()

@property (nonatomic, weak) UIView * emotionsContentView;

@end

@implementation MYZEmotionListCell


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = MYZRandomColor;
        
        UIView * emotionsContentView = [[UIView alloc] init];
        [self.contentView addSubview:emotionsContentView];
        self.emotionsContentView = emotionsContentView;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.emotionsContentView.frame = self.contentView.bounds;
}

@end
