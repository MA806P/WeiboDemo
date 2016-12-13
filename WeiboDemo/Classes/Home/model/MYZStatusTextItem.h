//
//  MYZStatusTextItem.h
//  WeiboDemo
//
//  Created by MA806P on 2016/12/5.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, StatusTextItemType)
{
    StatusTextItemTypeEmotion = 1,
    StatusTextItemTypeUser,
    StatusTextItemTypeTopic,
    StatusTextItemTypeUrl,
};

@interface MYZStatusTextItem : NSObject

@property (nonatomic, copy) NSString * text;

@property (nonatomic, assign) NSRange range;

@property (nonatomic, assign) StatusTextItemType type;

/** 在StatusTextLabel中所在的位置可能有换行 */
@property (nonatomic, copy) NSArray * rects;

//@property (nonatomic, strong) NSAttributedString * attributedText;

@end
