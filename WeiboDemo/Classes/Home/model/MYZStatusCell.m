//
//  MYZStatusCell.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/19.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusCell.h"
#import "MYZStatusFrame.h"
#import "MYZStatus.h"
#import "MYZStatusRetweeted.h"
#import "MYZStatusPic.h"
#import "MYZUserInfo.h"
#import "MYZStatusFrameTop.h"
#import "MYZStatusFrameMiddle.h"



@interface MYZStatusCell ()

@property (nonatomic, weak) UIButton * contentBgView;

@property (nonatomic, weak) UIView * topView; //上部视图,包括头像原创微博正文
@property (nonatomic, weak) UIImageView * iconImgView; //头像
@property (nonatomic, weak) UIImageView * iconPersonV;//个人大v标志
@property (nonatomic, weak) UIImageView * iconEnterpriseV; //企业大V标志
@property (nonatomic, weak) UILabel * nameLabel; //昵称
@property (nonatomic, weak) UILabel * timeLabel; //时间
@property (nonatomic, weak) UILabel * fromLabel; //来源
@property (nonatomic, weak) UILabel * selfTextLabel; //原创微博正文

@property (nonatomic, weak) UIView * middleView; //中部视图,转发的微博正文
@property (nonatomic, weak) UILabel * reTextLabel;

@property (nonatomic, weak) UIView * bottomView; //下部视图,评论转发点赞


@end

@implementation MYZStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        
        //子控件初始化
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews
{

    //cell背景整个button作为背景方便点击修改图片
    UIButton * contentBgView = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentBgView setBackgroundImage:[UIImage myz_stretchImageWithName:@"timeline_card_background"] forState:UIControlStateNormal];
    [contentBgView setBackgroundImage:[UIImage myz_stretchImageWithName:@"timeline_card_background_highlighted"] forState:UIControlStateHighlighted];
    [contentBgView addTarget:self action:@selector(statusCellTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:contentBgView];
    self.contentBgView = contentBgView;
    
//上部视图,包括头像原创微博正文
    UIView * topView = [[UIView alloc] init];
    //topView.backgroundColor = [UIColor clearColor];
    topView.userInteractionEnabled = NO;
    [contentBgView addSubview:topView];
    self.topView = topView;
    
    //头像
    UIImageView * iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:@"avator_default"];
    [topView addSubview:iconImgView];
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
    [topView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:StatusFontTimeFromSize];
    [topView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    //来源
    UILabel * fromLabel = [[UILabel alloc] init];
    fromLabel.font = [UIFont systemFontOfSize:StatusFontTimeFromSize];
    [topView addSubview:fromLabel];
    self.fromLabel = fromLabel;
    
    //原创微博正文
    UILabel * selfTextLabel = [[UILabel alloc] init];
    selfTextLabel.font = [UIFont systemFontOfSize:StatusFontTextSize];
    selfTextLabel.numberOfLines = 0;
    [topView addSubview:selfTextLabel];
    self.selfTextLabel = selfTextLabel;
    
    
    
    
    
    
//中部视图,转发的微博正文
    UIButton * middleView = [UIButton buttonWithType:UIButtonTypeCustom];
    [middleView setBackgroundImage:[UIImage myz_stretchImageWithName:@"timeline_retweet_background"] forState:UIControlStateNormal];
    [middleView setBackgroundImage:[UIImage myz_stretchImageWithName:@"timeline_retweet_background_highlighted"] forState:UIControlStateHighlighted];
    [middleView addTarget:self action:@selector(statusRetweetedTouch) forControlEvents:UIControlEventTouchUpInside];
    [contentBgView addSubview:middleView];
    self.middleView = middleView;
    
    UILabel * reTextLabel = [[UILabel alloc] init];
    reTextLabel.font = [UIFont systemFontOfSize:StatusFontTextSize];
    reTextLabel.numberOfLines = 0;
    [middleView addSubview:reTextLabel];
    self.reTextLabel = reTextLabel;
    
    
    
    
//下部视图,评论转发点赞
    UIView * bottomView = [[UIView alloc] init];
    bottomView.userInteractionEnabled = NO;
    [contentBgView addSubview:bottomView];
    self.bottomView = bottomView;
}


- (void)setStatusFrame:(MYZStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    MYZStatus * status = statusFrame.status;
    MYZUserInfo * user = status.user;
    MYZStatusRetweeted * statusRetweeted = status.retweeted_status;
    
    MYZStatusFrameTop * frameTop = statusFrame.frameTop;
    MYZStatusFrameMiddle * frameMiddle = statusFrame.frameMiddle;
    
    
    self.contentBgView.frame = statusFrame.frame;
    
//上部视图
    self.topView.frame = frameTop.frame;
    self.iconImgView.frame = frameTop.frameIcon;
    //[self.iconImgView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avator_default"]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:user.profile_image_url] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        self.iconImgView.image = [UIImage myz_imageWithCircleClipImage:image andBorderWidth:2 andBorderColor:MYZColor(247, 247, 247)];
    }];
    
    //大V认证图标
    self.iconPersonV.x = frameTop.frameIcon.size.width - self.iconPersonV.width;
    self.iconPersonV.y = frameTop.frameIcon.size.height - self.iconPersonV.height;
    self.iconPersonV.hidden = YES;
    self.iconEnterpriseV.x = frameTop.frameIcon.size.width - self.iconEnterpriseV.width;
    self.iconEnterpriseV.y = frameTop.frameIcon.size.height - self.iconEnterpriseV.height;
    self.iconEnterpriseV.hidden = YES;
    if (user.verified)
    {
        //** verified_type 认证类型 -1 未认证, 0个人认证, >=2企业认证 */
        if (user.verified_type == 0)
        {
            self.iconPersonV.hidden = NO;
        }
        else if (user.verified_type > 1)
        {
            self.iconEnterpriseV.hidden = NO;
        }
    }
    
    //名称
    self.nameLabel.frame = frameTop.frameName;
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
    self.timeLabel.frame = frameTop.frameTime;
    self.timeLabel.width = [createStr myz_stringSizeWithMaxSize:CGSizeMake(200, self.timeLabel.frame.size.height) andFont:[UIFont systemFontOfSize:StatusFontTimeFromSize]].width;
    
    self.fromLabel.text = status.source;
    self.fromLabel.frame = frameTop.frameSource;
    self.fromLabel.x = CGRectGetMaxX(self.timeLabel.frame) + StatusMarginTimeFrom;
    
    self.selfTextLabel.frame = frameTop.frameText;
    self.selfTextLabel.text = status.text;
    
//中部视图
    self.middleView.frame = frameMiddle.frame;
    self.reTextLabel.frame = frameMiddle.frameReText;
    self.reTextLabel.text = [NSString stringWithFormat:@"@%@: %@",statusRetweeted.user.name, statusRetweeted.text];
    
    
//下部视图
    self.bottomView.frame = statusFrame.frameBottom;
    
}




#pragma mark - cell 点击时间

//整个cell点击
- (void)statusCellTouch
{
    MYZLog(@" --- statusCellTouch");
}


//转发微博点击
- (void)statusRetweetedTouch
{
    MYZLog(@" --- statusRetweetedTouch");
}



@end
