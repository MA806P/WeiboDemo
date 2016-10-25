//
//  LabelScrollView.m
//  UITest
//
//  Created by 159CaiMini02 on 16/10/25.
//  Copyright © 2016年 myz. All rights reserved.
//

#import "LabelScrollView.h"

static double const TimeInterval = 2.0; //时间间隔

@interface LabelScrollView ()

@property (nonatomic, weak) UILabel * nowLabel;
@property (nonatomic, weak) UILabel * nextLabel;

@property (nonatomic, assign) NSInteger index;

@property(nonatomic,strong) NSTimer * timer;

@end

@implementation LabelScrollView


/**
 LabelScrollView * labScroll = [[LabelScrollView alloc] initWithFrame:CGRectMake(30, 100, 200, 60)];
 labScroll.textArray = @[@"111111111111111", @"222222222222", @"333333333333", @"444444444"];
 [self.view addSubview:labScroll];
 self.labelScrollView = labScroll;
 
 
 
 if (btn.isSelected)
 {
 self.labelScrollView.textArray = @[@"5555"];
 }
 else
 {
 self.labelScrollView.textArray = @[@"aaaaaa",@"bbbbbb",@"ccccc",@"ddddd"];
 }
 
 */


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor brownColor];
        self.bounces = NO;
        self.userInteractionEnabled = NO;
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 2.0);
        
        CGRect frame = self.bounds;
        
        UILabel * label1 = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:label1];
        self.nowLabel = label1;
        
        frame.origin.y += frame.size.height;
        
        UILabel * label2 = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:label2];
        self.nextLabel = label2;
    }
    return self;
}




- (void)setTextArray:(NSArray *)textArray
{
    _textArray = textArray;
    
    if (textArray.count > 0)
    {
        [self removeTimer];
    }
    
    //self.contentOffset = CGPointMake(0, self.frame.size.height);
    if (textArray.count == 1)
    {
        self.nowLabel.text = textArray[0];
        self.nextLabel.text = textArray[0];
    }
    else if (textArray.count > 1)
    {
        self.nowLabel.text = textArray[0];
        self.nextLabel.text = textArray[1];
        
        [self addTimer];
    }
    
    
}







//添加计时器
- (void) addTimer
{
    if (self.timer) return;
    self.index = 1;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    
}


//移除定时器
- (void)removeTimer
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}


//滚动到下一页
- (void)nextPage
{
    self.index = (self.index + 1) % self.textArray.count;
    
//    CGRect tempNowFrame = self.nowLabel.frame;
//    CGRect tempNextFrame = self.nextLabel.frame;
//    
//    tempNowFrame.origin.y += tempNowFrame.size.height;
//    tempNextFrame.origin.y += tempNextFrame.size.height;
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        self.nowLabel.frame = tempNowFrame;
//        self.nextLabel.frame = tempNextFrame;
//        
//        
//    } completion:^(BOOL finished) {
//        
//        self.nowLabel.frame = CGRectMake(0, -tempNowFrame.size.height, tempNowFrame.size.width, tempNowFrame.size.height);
//        self.nowLabel.text = self.textArray[self.index];
//        
//        UILabel * tempLab = self.nowLabel;
//        self.nowLabel = self.nextLabel;
//        self.nextLabel = tempLab;
//        
//        
//        NSLog(@"------ %@  %@ ", NSStringFromCGRect(self.nowLabel.frame), NSStringFromCGRect(self.nextLabel.frame));
//        
//    }];
    
    
    CGFloat h = self.frame.size.height;
    
    
    [UIView animateWithDuration:1.0 animations:^{
        self.contentOffset = CGPointMake(0, h);
    } completion:^(BOOL finished) {
        self.contentOffset = CGPointMake(0, 0);
        NSLog(@"---- %@ ", self.textArray);
        if (self.index < self.textArray.count)
        {
            self.nowLabel.text = self.nextLabel.text;
            self.nextLabel.text = self.textArray[self.index];
        }
        
    }];
    
    
}




@end
