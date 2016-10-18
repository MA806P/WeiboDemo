//
//  UIView+MYZ.m
//  CategoryProject
//
//  Created by 159CaiMini02 on 16/7/6.
//  Copyright © 2016年 myz. All rights reserved.
//

#import "UIView+MYZ.h"

@implementation UIView (MYZ)

- (void)setX:(CGFloat)x
{
    CGRect rect=self.frame;
    rect.origin.x=x;
    
    self.frame=rect;
}
-(CGFloat)x
{
    return self.frame.origin.x;
}


-(void)setY:(CGFloat)y
{
    CGRect rect=self.frame;
    rect.origin.y=y;
    
    self.frame=rect;
}
-(CGFloat)y
{
    return self.frame.origin.y;
}

-(void)setOrigin:(CGPoint)origin
{
    [self setX:origin.x];
    [self setY:origin.y];
}

- (CGPoint)origin
{
    return self.frame.origin;
}

-(void)setWidth:(CGFloat)width
{
    CGRect rect=self.frame;
    rect.size.width=width;
    
    self.frame=rect;
}
-(CGFloat)width
{
    return self.size.width;
}

-(void)setHeight:(CGFloat)height
{
    CGRect rect=self.frame;
    rect.size.height=height;
    
    self.frame=rect;
}
-(CGFloat)height
{
    return self.size.height;
}

-(void)setSize:(CGSize)size
{
    [self setWidth:size.width];
    [self setHeight:size.height];
}

- (CGSize)size
{
    return self.frame.size;
}


@end
