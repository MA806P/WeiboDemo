//
//  UIImage+MYZ.m
//  CategoryProject
//
//  Created by MYZ on 16/6/13.
//  Copyright © 2016年 myz. All rights reserved.
//

#import "UIImage+MYZ.h"
#import <ImageIO/ImageIO.h>

CGFloat const marginRight = 8;
CGFloat const marginBottom = 5;

@implementation UIImage (MYZ)


+ (UIImage *)myz_imageWithImageName:(NSString *)name andMarkImageName:(NSString *)markImageName
{
    
    UIImage * image = [UIImage imageNamed:name];
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [image drawAtPoint:CGPointZero];
    
    UIImage * markImage = [UIImage imageNamed:markImageName];
    
    CGFloat markX = image.size.width - markImage.size.width - marginRight;
    CGFloat markY = image.size.height - markImage.size.height - marginBottom;
    [markImage drawAtPoint:CGPointMake(markX, markY)];
    
    UIImage * getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getImage;
}



+ (UIImage *)myz_imageWithImageName:(NSString *)name andMarkTitle:(NSString *)title
{
    UIImage * image = [UIImage imageNamed:name];
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    [image drawAtPoint:CGPointZero];
    
    NSString * markTitle = [NSString stringWithFormat:@"@%@",title];
    
    UIFont * titleFont = [UIFont systemFontOfSize:16];
    NSDictionary * titleAttributes = @{NSFontAttributeName:titleFont, NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGSize titleSize = [markTitle boundingRectWithSize:image.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:titleAttributes context:nil].size;
    
    CGFloat markX = image.size.width - titleSize.width - marginRight;
    CGFloat markY = image.size.height - titleSize.height - marginBottom;
    [markTitle drawAtPoint:CGPointMake(markX, markY) withAttributes:titleAttributes];
    
    UIImage * getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getImage;
}



+ (UIImage *)myz_imageWithCircleClipImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef cr = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(cr, CGRectMake(0, 0, image.size.width, image.size.height));
    CGContextClip(cr);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage * getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getImage;

}

+ (UIImage *)myz_imageWithCircleClipImage:(UIImage *)image andBorderWidth:(CGFloat)width andBorderColor:(UIColor *)color
{
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    CGFloat imageX;
    CGFloat imageY;
    CGFloat equalWH;
    if (imageW >= imageH)
    {
        equalWH = imageH;
        imageX = -(imageW - imageH)*0.5;
        imageY = 0;
    }
    else
    {
        equalWH = imageW;
        imageX = 0;
        imageY = -(imageH - imageW)*0.5;
    }
    
    
    CGSize borderCircleSize = CGSizeMake(equalWH + width*2, equalWH + width*2);
    UIGraphicsBeginImageContextWithOptions(borderCircleSize, NO, 0);
    
    CGContextRef cr = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(cr, CGRectMake(0, 0, borderCircleSize.width, borderCircleSize.height));
    [color set];
    CGContextFillPath(cr);
    
    CGRect clipFrame = CGRectMake(width, width, equalWH, equalWH);
    CGContextAddEllipseInRect(cr, clipFrame);
    CGContextClip(cr);
    
    
    [image drawInRect:CGRectMake(imageX+width, imageY+width, image.size.width, image.size.height)];
    UIImage * getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getImage;
    
}


+ (UIImage *)myz_imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef cr = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(cr, color.CGColor);
    //CGContextFillRect(cr, CGRectMake(0, 0, size.width, size.height));
    
    CGContextAddRect(cr, CGRectMake(0, 0, size.width, size.height));
    [color set];
    CGContextFillPath(cr);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)myz_imageWithViewScreenShot:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - gif 

static int delayCentisecondsForImageAtIndex(CGImageSourceRef const source, size_t const i)
{
    int delayCentiseconds = 1;
    CFDictionaryRef const properties = CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
    if (properties)
    {
        CFDictionaryRef const gifProperties = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gifProperties)
        {
            NSNumber *number = (__bridge id) CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFUnclampedDelayTime);
            if (number == NULL || [number doubleValue] == 0)
            {
                number = (__bridge id) CFDictionaryGetValue(gifProperties, kCGImagePropertyGIFDelayTime);
            }
            if ([number doubleValue] > 0)
            {
                delayCentiseconds = (int)lrint([number doubleValue] * 100);
            }
        }
        CFRelease(properties);
    }
    return delayCentiseconds;
}

static void createImagesAndDelays(CGImageSourceRef source, size_t count, CGImageRef imagesOut[count], int delayCentisecondsOut[count])
{
    for (size_t i = 0; i < count; ++i)
    {
        imagesOut[i] = CGImageSourceCreateImageAtIndex(source, i, NULL);
        delayCentisecondsOut[i] = delayCentisecondsForImageAtIndex(source, i);
    }
}

static int sum(size_t const count, int const *const values)
{
    int theSum = 0;
    for (size_t i = 0; i < count; ++i)
    {
        theSum += values[i];
    }
    return theSum;
}

static int pairGCD(int a, int b)
{
    if (a < b)
    {
        return pairGCD(b, a);
    }
    
    while (true)
    {
        int const r = a % b;
        if (r == 0)
        {
            return b;
        }
        a = b;
        b = r;
    }
}

static int vectorGCD(size_t const count, int const *const values)
{
    int gcd = values[0];
    for (size_t i = 1; i < count; ++i)
    {
        gcd = pairGCD(values[i], gcd);
    }
    return gcd;
}

static NSArray *frameArray(size_t const count, CGImageRef const images[count], int const delayCentiseconds[count], int const totalDurationCentiseconds)
{
    int const gcd = vectorGCD(count, delayCentiseconds);
    size_t const frameCount = totalDurationCentiseconds / gcd;
    UIImage *frames[frameCount];
    for (size_t i = 0, f = 0; i < count; ++i)
    {
        UIImage *const frame = [UIImage imageWithCGImage:images[i]];
        for (size_t j = delayCentiseconds[i] / gcd; j > 0; --j)
        {
            frames[f++] = frame;
        }
    }
    return [NSArray arrayWithObjects:frames count:frameCount];
}

static void releaseImages(size_t const count, CGImageRef const images[count])
{
    for (size_t i = 0; i < count; ++i)
    {
        CGImageRelease(images[i]);
    }
}

static UIImage *animatedImageWithAnimatedGIFImageSource(CGImageSourceRef const source)
{
    size_t const count = CGImageSourceGetCount(source);
    CGImageRef images[count];
    int delayCentiseconds[count]; // in centiseconds
    createImagesAndDelays(source, count, images, delayCentiseconds);
    int const totalDurationCentiseconds = sum(count, delayCentiseconds);
    NSArray *const frames = frameArray(count, images, delayCentiseconds, totalDurationCentiseconds);
    UIImage *const animation = [UIImage animatedImageWithImages:frames duration:(NSTimeInterval)totalDurationCentiseconds / 100.0];
    releaseImages(count, images);
    return animation;
}

static UIImage *animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceRef CF_RELEASES_ARGUMENT source)
{
    if (source)
    {
        UIImage *const image = animatedImageWithAnimatedGIFImageSource(source);
        CFRelease(source);
        return image;
    }
    else
    {
        return nil;
    }
}

+ (UIImage *)myz_imageWithAnimatedGIFData:(NSData *)data
{
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithData((__bridge CFTypeRef) data, NULL));
}

+ (UIImage *)myz_imageWithAnimatedGIFURL:(NSURL *)url
{
    return animatedImageWithAnimatedGIFReleasingImageSource(CGImageSourceCreateWithURL((__bridge CFTypeRef) url, NULL));
}



@end
