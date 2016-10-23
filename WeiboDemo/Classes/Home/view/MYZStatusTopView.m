//
//  MYZStatusTopView.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusTopView.h"
#import "MYZUserInfo.h"
#import "MYZStatus.h"
#import "MYZStatusFrameTop.h"

@interface MYZStatusTopView ()

@property (nonatomic, weak) UIImageView * iconImgView; //头像
@property (nonatomic, weak) UIImageView * iconPersonV;//个人大v标志
@property (nonatomic, weak) UIImageView * iconEnterpriseV; //企业大V标志
@property (nonatomic, weak) UILabel * nameLabel; //昵称
@property (nonatomic, weak) UILabel * timeLabel; //时间
@property (nonatomic, weak) UILabel * fromLabel; //来源
@property (nonatomic, weak) UILabel * selfTextLabel; //原创微博正文
@property (nonatomic, weak) UIView * picsContentView; //原创微博配图

@end

@implementation MYZStatusTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.image = [UIImage myz_stretchImageWithName:@"common_card_top_background"];
        
        //创建子控件
        [self createSubviews];
    }
    return self;
}


- (void)createSubviews
{
    //上部视图,包括头像原创微博正文
    //头像
    UIImageView * iconImgView = [[UIImageView alloc] init];
    [self addSubview:iconImgView];
    self.iconImgView = iconImgView;
    
    //认证图标
    UIImageView * iconPersonV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_vip"]];
    iconPersonV.hidden = YES;
    [iconImgView addSubview:iconPersonV];
    self.iconPersonV = iconPersonV;
    
    UIImageView * iconEnterpriseV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_enterprise_vip"]];
    iconEnterpriseV.hidden = YES;
    [iconImgView addSubview:iconEnterpriseV];
    self.iconEnterpriseV = iconEnterpriseV;
    
    //昵称
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:StatusFontNameSize];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:StatusFontTimeFromSize];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    //来源
    UILabel * fromLabel = [[UILabel alloc] init];
    fromLabel.font = [UIFont systemFontOfSize:StatusFontTimeFromSize];
    [self addSubview:fromLabel];
    self.fromLabel = fromLabel;
    
    //原创微博正文
    UILabel * selfTextLabel = [[UILabel alloc] init];
    selfTextLabel.font = [UIFont systemFontOfSize:StatusFontTextSize];
    selfTextLabel.numberOfLines = 0;
    [self addSubview:selfTextLabel];
    self.selfTextLabel = selfTextLabel;
    
    //原创微博配图
    UIView * picsContentView = [[UIView alloc] init];
    picsContentView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:picsContentView];
    self.picsContentView = picsContentView;
}


- (void)setStatusFrameTop:(MYZStatusFrameTop *)statusFrameTop
{
    _statusFrameTop = statusFrameTop;
    
    MYZStatus * status = statusFrameTop.status;
    MYZUserInfo * user = status.user;
    
    
    //上部视图
    self.frame = statusFrameTop.frame;
    self.iconImgView.frame = statusFrameTop.frameIcon;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avator_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            self.iconImgView.image = [UIImage myz_imageWithCircleClipImage:image andBorderWidth:2 andBorderColor:MYZColor(247, 247, 247)];
        }
    }];
    
    
    //大V认证图标
    self.iconPersonV.hidden = YES;
    self.iconEnterpriseV.hidden = YES;
    if (user.verified)
    {
        //** verified_type 认证类型 -1 未认证, 0个人认证, >=2企业认证 */
        if (user.verified_type == 0)
        {
            self.iconPersonV.x = statusFrameTop.frameIcon.size.width - self.iconPersonV.width;
            self.iconPersonV.y = statusFrameTop.frameIcon.size.height - self.iconPersonV.height;
            self.iconPersonV.hidden = NO;
        }
        else if (user.verified_type > 1)
        {
            self.iconEnterpriseV.x = statusFrameTop.frameIcon.size.width - self.iconEnterpriseV.width;
            self.iconEnterpriseV.y = statusFrameTop.frameIcon.size.height - self.iconEnterpriseV.height;
            self.iconEnterpriseV.hidden = NO;
        }
    }
    
    //名称
    self.nameLabel.frame = statusFrameTop.frameName;
    self.nameLabel.text = user.name;
    //是否会员，设置名字颜色
    if(user.isVip)
    {
        self.nameLabel.textColor = [UIColor colorWithRed:0.747 green:0.385 blue:0.021 alpha:1.000];
    }
    else
    {
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    NSString * createStr = status.createdStr;
    self.timeLabel.text = createStr;
    //重新计算时间和来源的frame，因为时间是变化的。
    self.timeLabel.frame = statusFrameTop.frameTime;
    self.timeLabel.width = [createStr myz_stringSizeWithMaxSize:CGSizeMake(200, self.timeLabel.frame.size.height) andFont:[UIFont systemFontOfSize:StatusFontTimeFromSize]].width;
    
    self.fromLabel.text = status.source;
    self.fromLabel.frame = statusFrameTop.frameSource;
    self.fromLabel.x = CGRectGetMaxX(self.timeLabel.frame) + StatusMarginTimeFrom;
    
    self.selfTextLabel.frame = statusFrameTop.frameText;
    self.selfTextLabel.text = status.text;
    
    MYZLog(@" --- %ld  %@", status.pic_urls.count, NSStringFromCGRect(statusFrameTop.framePicsContent));
    self.picsContentView.frame = statusFrameTop.framePicsContent;
    
}


//微博cell的选中状态，根据此值来设置背景图
- (void)setCellType:(MYZStatusCellType)cellType
{
    _cellType = cellType;
    
    if (cellType == MYZStatusCellTypeHighlighted)
    {
        self.image = [UIImage myz_stretchImageWithName:@"common_card_top_background_highlighted"];
    }
    else
    {
        self.image = [UIImage myz_stretchImageWithName:@"common_card_top_background"];
    }
}


@end
