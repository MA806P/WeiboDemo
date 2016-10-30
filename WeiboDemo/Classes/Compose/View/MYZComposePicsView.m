//
//  MYZComposePicsView.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZComposePicsView.h"

@implementation MYZComposePicsView

- (void)addImageInView:(UIImage *)image
{
    UIImageView * imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.image = image;
    [self addSubview:imgView];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageWH = (self.frame.size.width - ComposePicMarginAmong * (ComposePicRowColumnCount-1))/(ComposePicRowColumnCount * 1.0);
    CGFloat imageX = 0.0;
    CGFloat imageY = 0.0;
    
    for (NSInteger i=0; i<self.subviews.count; i++)
    {
        imageX = (i%ComposePicRowColumnCount) * (imageWH + ComposePicMarginAmong);
        imageY = (i/ComposePicRowColumnCount) * (imageWH + ComposePicMarginAmong);
        
        UIImageView * imgView = self.subviews[i];
        imgView.frame = CGRectMake(imageX, imageY, imageWH, imageWH);
        
    }
    
}


- (NSArray *)imageArray
{
    NSMutableArray * images = [NSMutableArray array];
    
    for (UIImageView * imgView in self.subviews)
    {
        [images addObject:imgView.image];
    }
    return images;
}


@end
