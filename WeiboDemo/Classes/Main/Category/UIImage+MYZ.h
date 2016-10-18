//
//  UIImage+MYZ.h
//  CategoryProject
//
//  Created by MYZ on 16/6/13.
//  Copyright © 2016年 myz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MYZ)

/**
 *  添加图片水印
 *
 *  @param name          图片名
 *  @param markImageName 水印图片名
 *
 *  @return 添加过水印的图片
 */
+ (UIImage *)myz_imageWithImageName:(NSString *)name andMarkImageName:(NSString *)markImageName;

/**
 *  添加文字水印
 *
 *  @param name  图片名
 *  @param title 要加水印的文字
 *
 *  @return 添加过文字的水印
 */
+ (UIImage *)myz_imageWithImageName:(NSString *)name andMarkTitle:(NSString *)title;

/**
 *  剪切圆形图片
 *
 *  @param image 要剪切的图片
 *
 *  @return 圆形图片
 */
+ (UIImage *)myz_imageWithCircleClipImage:(UIImage *)image;

/**
 *  剪切带有边框的圆形图片
 *
 *  @param image 要剪切的图片
 *  @param width 边框宽度
 *  @param color 边框的颜色
 *
 *  @return 带有边框的圆形图片
 */
+ (UIImage *)myz_imageWithCircleClipImage:(UIImage *)image andBorderWidth:(CGFloat)width andBorderColor:(UIColor *)color;

/**
 *  根据颜色来创建图片
 *
 *  @param color 图片颜色
 *  @param size  图片大小
 *
 *  @return 纯色的图片
 */
+ (UIImage *)myz_imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 *  获取对应视图的截图
 *
 *  @param view 要截图的View
 *
 *  @return 截图
 */
+ (UIImage *)myz_imageWithViewScreenShot:(UIView *)view;



/** gif data 生成UIImage */
+ (UIImage *)myz_imageWithAnimatedGIFData:(NSData *)data;
+ (UIImage *)myz_imageWithAnimatedGIFURL:(NSURL *)url;




@end
