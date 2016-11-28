//
//  MYZEmotionPreview.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/11/24.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionPreview.h"
#import "MYZEmotionView.h"
#import "MYZEmotion.h"

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
        
        MYZEmotionView * emotionView = [[MYZEmotionView alloc] initWithFrame:CGRectMake(14, 10, 36, 36)];
        [self addSubview:emotionView];
        self.emotionView = emotionView;
    }
    return self;
}


- (void)showFromEmotionView:(MYZEmotionView *)emotionView
{
    if (emotionView == nil || [self.emotionView.emotion isEqual:emotionView.emotion]) {
        return;
    }
    
    self.emotionView.emotion = emotionView.emotion;
    
    CGFloat centerY = emotionView.center.y - self.frame.size.height * 0.5;
    CGPoint selfCenter = CGPointMake(emotionView.center.x, centerY);
    
    UIWindow * lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    
    self.center = [lastWindow convertPoint:selfCenter fromView:emotionView.superview];
    MYZLog(@" showFromEmotionView - %@ %@ ",NSStringFromCGRect(self.frame) , NSStringFromCGPoint(selfCenter));
    [lastWindow addSubview:self];
    
    __block CGRect emotionFrame = self.emotionView.frame;
    emotionFrame.origin.y += 8;
    self.emotionView.frame = emotionFrame;
    
    [UIView animateWithDuration:0.1 animations:^{
        emotionFrame.origin.y -= 10;
        self.emotionView.frame = emotionFrame;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            self.emotionView.frame = CGRectMake(14, 10, 36, 36);
        }];
    }];
    
    
}

- (void)dismiss
{
    [self removeFromSuperview];
}




@end
