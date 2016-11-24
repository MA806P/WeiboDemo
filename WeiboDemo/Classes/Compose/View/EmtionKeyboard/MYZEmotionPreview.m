//
//  MYZEmotionPreview.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/11/24.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionPreview.h"
#import "MYZEmotionView.h"

@interface MYZEmotionPreview ()

@property (nonatomic, weak) MYZEmotionView * emotionView;

@end

@implementation MYZEmotionPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIImage * bgImg = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
        self.frame = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
        UIImageView * bgImageView = [[UIImageView alloc] initWithImage:bgImg];
        [self addSubview:bgImageView];
        
        MYZEmotionView * emotionView = [[MYZEmotionView alloc] initWithFrame:CGRectMake(16, 15, 32, 32)];
        [self addSubview:emotionView];
        self.emotionView = emotionView;
    }
    return self;
}


- (void)showFromEmotionView:(MYZEmotionView *)emotionView
{
    if (emotionView == nil) {
        return;
    }
    
    self.emotionView.emotion = emotionView.emotion;
    
    CGFloat centerY = CGRectGetMaxY(emotionView.frame) - self.frame.size.height * 0.5;
    CGPoint selfCenter = CGPointMake(emotionView.center.x, centerY);
    
    UIWindow * lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    
    self.center = [lastWindow convertPoint:selfCenter fromView:emotionView];
    MYZLog(@" showFromEmotionView - %@ %@ ",NSStringFromCGRect(self.frame) , NSStringFromCGPoint(selfCenter));
    [lastWindow addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}




@end
