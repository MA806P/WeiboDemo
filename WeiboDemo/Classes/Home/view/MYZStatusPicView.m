//
//  MYZStatusPicView.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/26.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusPicView.h"

#import "MYZStatusPic.h"

@interface MYZStatusPicView()

@property (nonatomic, weak) UIImageView *gifView;

@end

@implementation MYZStatusPicView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
        // 添加一个gif图标
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
        
    }
    return self;
}



- (void)setPicData:(MYZStatusPic *)picData
{
    _picData = picData;
    
    [self sd_setImageWithURL:[NSURL URLWithString:picData.thumbnail_pic] placeholderImage:[UIImage myz_stretchImageWithName:@"timeline_image_placeholder"]];
    
    NSString * extensionStr = picData.thumbnail_pic.pathExtension.lowercaseString;
    self.gifView.hidden = ![extensionStr isEqualToString:@"gif"];
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}



@end
