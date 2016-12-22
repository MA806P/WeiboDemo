//
//  MYZStatusBottomView.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/23.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusBottomView.h"
#import "MYZStatusOriginal.h"

@interface MYZStatusBottomView ()

@property (nonatomic, weak) UIButton *repostsBtn;
@property (nonatomic, weak) UIButton *commentsBtn;
@property (nonatomic, weak) UIButton *attitudesBtn;

@end

@implementation MYZStatusBottomView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.image = [UIImage myz_stretchImageWithName:@"common_card_bottom_background"];
        
        //创建子控件
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    CGFloat singleLineW = 1.0/[UIScreen mainScreen].scale;
    
    CGFloat btnW = (SCREEN_W - singleLineW*2.0)/3.0;
    CGFloat btnH = StatusBottomH;
    CGFloat btnY = 0.0;
    
    
    self.repostsBtn = [self createBtnWithTitle:@"转发" NormalImageName:@"timeline_icon_retweet"];
    self.repostsBtn.frame = CGRectMake(0, btnY, btnW, btnH);
    [self.repostsBtn addTarget:self action:@selector(repostsBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * separeLine1View = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    separeLine1View.x = CGRectGetMaxX(self.repostsBtn.frame);
    [self addSubview:separeLine1View];
    
    self.commentsBtn = [self createBtnWithTitle:@"评论" NormalImageName:@"timeline_icon_comment"];
    self.commentsBtn.frame = CGRectMake(CGRectGetMaxX(separeLine1View.frame), btnY, btnW, btnH);
    [self.commentsBtn addTarget:self action:@selector(commentsBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    UIImageView * separeLine2View = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    separeLine2View.x = CGRectGetMaxX(self.commentsBtn.frame);
    [self addSubview:separeLine2View];
    
    
    self.attitudesBtn = [self createBtnWithTitle:@"赞" NormalImageName:@"timeline_icon_unlike"];
    self.attitudesBtn.frame = CGRectMake(CGRectGetMaxX(separeLine2View.frame), btnY, btnW, btnH);
    [self.attitudesBtn addTarget:self action:@selector(attitudesBtnTouch) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 方法

- (UIButton *)createBtnWithTitle:(NSString *)title NormalImageName:(NSString *)normal
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage myz_stretchImageWithName:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0, 0, 0);
    
    [self addSubview:btn];
    
    return btn;
}






#pragma mark - 按钮点击

//转发
- (void)repostsBtnTouch
{
    MYZLog(@"repostsBtnTouch");
    [[NSNotificationCenter defaultCenter] postNotificationName:StatusRepostNoticKey object:nil userInfo:@{@"status":self.status}];
}

//评论
- (void)commentsBtnTouch
{
    MYZLog(@"commentsBtnTouch");
    [[NSNotificationCenter defaultCenter] postNotificationName:StatusCommentNoticKey object:self.status.mid];
}

//点赞
- (void)attitudesBtnTouch
{
    MYZLog(@"attitudesBtnTouch");
    [[NSNotificationCenter defaultCenter] postNotificationName:StatusLikeNoticKey object:self.status.mid];
}


#pragma mark - setter

- (void)setStatus:(MYZStatusOriginal *)status
{
    _status = status;
    
    [self setToolTitle:self.repostsBtn count:status.reposts_count defaultTitle:@"转发"];
    [self setToolTitle:self.commentsBtn count:status.comments_count defaultTitle:@"评论"];
    [self setToolTitle:self.attitudesBtn count:status.attitudes_count defaultTitle:@"赞"];
    
}

- (void)setToolTitle:(UIButton *)button count:(NSInteger)count defaultTitle:(NSString *)defaultTitle
{
    
    /**
     1.小于1W ： 具体数字，比如9800，就显示9800
     2.大于等于1W：xx.x万，比如78985，就显示7.9万
     3.整W：xx万，比如800365，就显示80万
     */
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%ld", count];
    }
    [button setTitle:defaultTitle forState:UIControlStateNormal];
}



//微博cell的选中状态，根据此值来设置背景图
- (void)setCellType:(MYZStatusCellType)cellType
{
    _cellType = cellType;
    
    if (cellType == MYZStatusCellTypeHighlighted)
    {
        self.image = [UIImage myz_stretchImageWithName:@"common_card_bottom_background_highlighted"];
    }
    else
    {
        self.image = [UIImage myz_stretchImageWithName:@"common_card_bottom_background"];
    }
}

@end
