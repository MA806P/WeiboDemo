//
//  MYZStatusPicContentView.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/26.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusPicContentView.h"
#import "MYZStatusPicView.h"
#import "MYZStatusPic.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@implementation MYZStatusPicContentView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //先创建九张图, 最多九张, 多余的根据数据判断隐藏
        for (NSInteger i = 0; i < 9; i++)
        {
            MYZStatusPicView * picView = [[MYZStatusPicView alloc] init];
            picView.tag = i;
            [self addSubview:picView];
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicAction:)];
            [picView addGestureRecognizer:tapGesture];
            
        }
    }
    return self;
}


//点击图片
- (void)tapPicAction:(UITapGestureRecognizer *)recognizer
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    for (NSInteger i = 0; i<self.picArray.count; i++) {
        MYZStatusPic *pic = (MYZStatusPic *)[self.picArray objectAtIndex:i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        // 设置图片的路径
        NSString * bmiddle_pic = [pic.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        photo.url = [NSURL URLWithString:bmiddle_pic];
        // 设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    
    // 3.显示浏览器
    [browser show];
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.picArray.count <= 0) { return; }
    
    NSInteger picCount = self.picArray.count;
    NSInteger columnCount = 3;
    NSInteger rowCount = (picCount - 1)/columnCount + 1;
    
    if (picCount == 1)
    {
        columnCount = 1;
        //rowCount = columnCount;
    }
    else if (picCount == 4)
    {
        columnCount = 2;
        //rowCount = columnCount;
    }
    
    
    CGFloat picW = (self.frame.size.width - StatusMarginPics*(columnCount-1))/columnCount * 1.0;
    CGFloat picH = (self.frame.size.height - StatusMarginPics*(rowCount-1))/rowCount * 1.0;
    
    for (NSInteger i = 0; i < picCount; i++)
    {
        NSInteger row = i%columnCount;
        NSInteger column = i/columnCount;
        
        CGFloat picX = (picW + StatusMarginPics) * row;
        CGFloat picY = (picH + StatusMarginPics) * column;
        
        MYZStatusPicView * picView = self.subviews[i];
        picView.frame = CGRectMake(picX, picY, picW, picH);
    }
    
    
}


- (void)setPicArray:(RLMArray *)picArray
{
    _picArray = picArray;
    
    for (NSInteger i = 0; i < 9; i++)
    {
        MYZStatusPicView * picView = self.subviews[i];
        
        if (i < picArray.count)
        {
            picView.picData = (MYZStatusPic *)[picArray objectAtIndex:i];
            picView.hidden = NO;
        }
        else
        {
            picView.hidden = YES;
        }
        
    }
    
}

@end
