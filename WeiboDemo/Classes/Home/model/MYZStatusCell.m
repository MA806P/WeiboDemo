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

@property (nonatomic, weak) UIView * topView; //上部视图,包括头像原创微博正文
@property (nonatomic, weak) UIImageView * iconImgView; //头像
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

    
//上部视图,包括头像原创微博正文
    UIView * topView = [[UIView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
    
    //头像
    UIImageView * iconImgView = [[UIImageView alloc] init];
    [topView addSubview:iconImgView];
    self.iconImgView = iconImgView;
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
    UIView * middleView = [[UIView alloc] init];
    [self.contentView addSubview:middleView];
    self.middleView = middleView;
    
    UILabel * reTextLabel = [[UILabel alloc] init];
    reTextLabel.font = [UIFont systemFontOfSize:StatusFontTextSize];
    reTextLabel.numberOfLines = 0;
    [middleView addSubview:reTextLabel];
    self.reTextLabel = reTextLabel;
    
    
    
    
//下部视图,评论转发点赞
    UIView * bottomView = [[UIView alloc] init];
    [self.contentView addSubview:bottomView];
    self.topView = bottomView;
}


- (void)setStatusFrame:(MYZStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    MYZStatus * status = statusFrame.status;
    MYZUserInfo * user = status.user;
    MYZStatusRetweeted * statusRetweeted = status.retweeted_status;
    
    MYZStatusFrameTop * frameTop = statusFrame.frameTop;
    MYZStatusFrameMiddle * frameMiddle = statusFrame.frameMiddle;
    
//上部视图
    self.topView.frame = frameTop.frame;
    self.iconImgView.frame = frameTop.frameIcon;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avator_default"]];
    
    self.nameLabel.frame = frameTop.frameName;
    self.nameLabel.text = user.name;
    
    self.timeLabel.frame = frameTop.frameTime;
    self.timeLabel.text = status.createdStr;
    NSLog(@"--- %@ ", status.createdStr);
    self.fromLabel.frame = frameTop.frameSource;
    self.fromLabel.text = status.sourceStr;
    
    self.selfTextLabel.frame = frameTop.frameText;
    self.selfTextLabel.text = status.text;
    
//中部视图
    self.middleView.frame = frameMiddle.frame;
    self.reTextLabel.frame = frameMiddle.frameReText;
    self.reTextLabel.text = [NSString stringWithFormat:@"@%@: %@",statusRetweeted.user.name, statusRetweeted.text];
    
//下部视图
    self.bottomView.frame = statusFrame.frameBottom;
    
}



@end
