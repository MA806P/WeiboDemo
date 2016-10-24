//
//  MYZStatusMiddleView.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusMiddleView.h"
#import "MYZUserInfo.h"
#import "MYZStatusRetweeted.h"
#import "MYZStatusFrameMiddle.h"

@interface MYZStatusMiddleView ()

@property (nonatomic, weak) UILabel * reTextLabel;

@property (nonatomic, weak) UIView * picsContentView;

@end

@implementation MYZStatusMiddleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.image = [UIImage myz_stretchImageWithName:@"timeline_retweet_background"];
        
        //创建子控件
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    UILabel * reTextLabel = [[UILabel alloc] init];
    reTextLabel.backgroundColor = [UIColor clearColor];
    reTextLabel.font = [UIFont systemFontOfSize:StatusFontTextSize];
    reTextLabel.numberOfLines = 0;
    [self addSubview:reTextLabel];
    self.reTextLabel = reTextLabel;
    
    UIView * picsContentView = [[UIView alloc] init];
    picsContentView.backgroundColor = [UIColor orangeColor];
    [self addSubview:picsContentView];
    self.picsContentView = picsContentView;
}

- (void)setStatusFrameMiddle:(MYZStatusFrameMiddle *)statusFrameMiddle
{
    _statusFrameMiddle = statusFrameMiddle;
    
    MYZStatusRetweeted * statusRetweeted = statusFrameMiddle.statusRetweeted;
    MYZUserInfo * user = statusRetweeted.user;
    
    self.reTextLabel.frame = statusFrameMiddle.frameReText;
    self.reTextLabel.text = [NSString stringWithFormat:@"@%@: %@",user.name, statusRetweeted.text];
    
    
    MYZLog(@"retweeted --- %ld  %@", statusRetweeted.pic_urls.count, NSStringFromCGRect(statusFrameMiddle.frameRePicContent));
    self.picsContentView.frame = statusFrameMiddle.frameRePicContent;
    
}

//微博cell的选中状态，根据此值来设置背景图
- (void)setCellType:(MYZStatusCellType)cellType
{
    _cellType = cellType;
    
    if (cellType == MYZStatusCellTypeHighlighted)
    {
        self.image = [UIImage myz_stretchImageWithName:@"timeline_retweet_background_highlighted"];
    }
    else
    {
        self.image = [UIImage myz_stretchImageWithName:@"timeline_retweet_background"];
    }
}

@end
