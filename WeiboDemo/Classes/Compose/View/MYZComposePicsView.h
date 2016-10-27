//
//  MYZComposePicsView.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSInteger const ComposePicRowColumnCount; //要发布的图片每行每列展示的个数
FOUNDATION_EXPORT CGFloat const ComposePicMarginAmong; //展示的图片和图片之间的间隙

@interface MYZComposePicsView : UIView

- (void)addImageInView:(UIImage *)image;

- (NSArray *)imageArray;

@end
