//
//  MYZStatusCell.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/19.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusCell.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusFrame.h"
#import "MYZStatusFrameTop.h"
#import "MYZStatusFrameMiddle.h"
#import "MYZStatusTopView.h"
#import "MYZStatusMiddleView.h"
#import "MYZStatusBottomView.h"
#import "MYZStatusRetweet.h"



@interface MYZStatusCell () <StatusBottomViewDelegate>

@property (nonatomic, weak) MYZStatusTopView * topView; //上部视图,包括头像原创微博正文

@property (nonatomic, weak) MYZStatusMiddleView * middleView; //中部视图,转发的微博正文

@property (nonatomic, weak) MYZStatusBottomView * bottomView; //下部视图,评论转发点赞


@end

@implementation MYZStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = MYZColor(242, 242, 242);
        
        
        //子控件初始化
        [self initSubViews];
        
        
    }
    return self;
}


- (void)initSubViews
{
    
    __weak typeof(self) weakSelf = self;
    
//上部视图,包括头像原创微博正文
    MYZStatusTopView * topView = [[MYZStatusTopView alloc] init];
    topView.statusTopViewBlock = ^(MYZStatusTextItem * textItem){
        __strong typeof(weakSelf) srongSelf = weakSelf;
        if (srongSelf)
        {
            [srongSelf statusTextLinkTouch:textItem];
        }
    };
    [self.contentView addSubview:topView];
    self.topView = topView;
    
    
    
//中部视图,转发的微博正文
    MYZStatusMiddleView * middleView = [[MYZStatusMiddleView alloc] init];
    middleView.statusMiddleViewBlock = ^(MYZStatusTextItem * textItem){
        __strong typeof(weakSelf) srongSelf = weakSelf;
        if (srongSelf)
        {
            [srongSelf statusTextLinkTouch:textItem];
        }
    };

    [self.contentView addSubview:middleView];
    self.middleView = middleView;
    
    
//下部视图,评论转发点赞
    MYZStatusBottomView * bottomView = [[MYZStatusBottomView alloc] init];
    bottomView.delegate = self;
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}


- (void)setStatusFrame:(MYZStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    MYZStatusOriginal * status = statusFrame.status;
    MYZStatusFrameTop * frameTop = statusFrame.frameTop;
    MYZStatusFrameMiddle * frameMiddle = statusFrame.frameMiddle;
    
    
//上部视图，原创微博头像名称内容
    self.topView.frame = frameTop.frame;
    self.topView.statusFrameTop = frameTop;
    
//中部视图，转发微博内容
    self.middleView.frame = frameMiddle.frame;
    self.middleView.statusFrameMiddle = frameMiddle;
    
//下部视图，转发 评论 点赞
    self.bottomView.frame = statusFrame.frameBottom;
    self.bottomView.status = status;
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted)
    {
        //MYZLog(@" --- highlighted");
        self.topView.cellType = MYZStatusCellTypeHighlighted;
        self.middleView.cellType = MYZStatusCellTypeHighlighted;
        self.bottomView.cellType = MYZStatusCellTypeHighlighted;
    }
    else
    {
        //MYZLog(@" --- no highlighted");
        self.topView.cellType = MYZStatusCellTypeNormal;
        self.middleView.cellType = MYZStatusCellTypeNormal;
        self.bottomView.cellType = MYZStatusCellTypeNormal;
    }
}


#pragma mark - 点击事件, 正文连接 评论 转发 点赞
//点击微博正文能点的地方
- (void)statusTextLinkTouch:(MYZStatusTextItem *) linkTextItem
{
    if ([self.delegate respondsToSelector:@selector(statusTouchTextLinkWithTextItem:statusFrame:)])
    {
        //点击微博中链接
        [self.delegate statusTouchTextLinkWithTextItem:linkTextItem statusFrame:self.statusFrame];
    }
}

//转发
- (void)statusBottomViewTouchRepost
{
    if ([self.delegate respondsToSelector:@selector(statusTouchRepostWithStatus:)])
    {
        [self.delegate statusTouchRepostWithStatus:self.statusFrame];
    }
}

//评论
- (void)statusBottomViewTouchComment
{
    if ([self.delegate respondsToSelector:@selector(statusTouchCommentWithStatus:)])
    {
        [self.delegate statusTouchCommentWithStatus:self.statusFrame];
    }
}

//点赞
- (void)statusBottomViewTouchLike
{
    if ([self.delegate respondsToSelector:@selector(statusTouchLikeWithStatus:)])
    {
        [self.delegate statusTouchLikeWithStatus:self.statusFrame];
    }
}

@end
