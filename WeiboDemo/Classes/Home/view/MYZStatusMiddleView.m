//
//  MYZStatusMiddleView.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusMiddleView.h"
#import "MYZUserInfo.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusRetweet.h"
#import "MYZStatusFrameMiddle.h"
#import "MYZStatusPicContentView.h"
#import "MYZStatusTextLabel.h"

@interface MYZStatusMiddleView ()

@property (nonatomic, weak) MYZStatusTextLabel * reTextLabel;

@property (nonatomic, weak) MYZStatusPicContentView * picsContentView;

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
//    UILabel * reTextLabel = [[UILabel alloc] init];
//    reTextLabel.backgroundColor = [UIColor clearColor];
//    reTextLabel.font = [UIFont systemFontOfSize:StatusFontTextSize];
//    reTextLabel.numberOfLines = 0;
    
    __weak typeof(self) weakSelf = self;
    MYZStatusTextLabel * reTextLabel = [[MYZStatusTextLabel alloc] init];
    reTextLabel.statusTextLabelBlock = ^(MYZStatusTextItem * textItem){
        __strong typeof(weakSelf) srongSelf = weakSelf;
        if (srongSelf && srongSelf.statusMiddleViewBlock)
        {
            srongSelf.statusMiddleViewBlock(textItem);
        }
    };
    [self addSubview:reTextLabel];
    self.reTextLabel = reTextLabel;
    
    MYZStatusPicContentView * picsContentView = [[MYZStatusPicContentView alloc] init];
    //picsContentView.backgroundColor = [UIColor orangeColor];
    [self addSubview:picsContentView];
    self.picsContentView = picsContentView;
}

- (void)setStatusFrameMiddle:(MYZStatusFrameMiddle *)statusFrameMiddle
{
    _statusFrameMiddle = statusFrameMiddle;
    
    MYZStatusOriginal * status = statusFrameMiddle.status;
    MYZStatusRetweet * statusRetweeted = status.retweeted_status;
    
    self.reTextLabel.frame = statusFrameMiddle.frameReText;
    
    //self.reTextLabel.text = statusRetweeted.text;
    //self.reTextLabel.attributedText = status.reAttributedText;
    self.reTextLabel.attributedString = status.reAttributedText;
    
    self.picsContentView.frame = statusFrameMiddle.frameRePicContent;
    self.picsContentView.picArray = statusRetweeted.pic_urls;
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
