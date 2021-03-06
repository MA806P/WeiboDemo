//
//  MYZEmotion.h
//  WeiboDemo
//
//  Created by MA806P on 2016/11/14.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYZEmotion : NSObject

/** 表情的文字描述,简体字 */
@property (nonatomic, copy) NSString *chs;
/** 表情的文字描述,繁体字 */
@property (nonatomic, copy) NSString *cht;
/** 表情的文png图片名 */
@property (nonatomic, copy) NSString *png;
/** emoji表情的编码 */
@property (nonatomic, copy) NSString *code;


/** 表情的存放文件夹\目录 */
@property (nonatomic, copy) NSString *directory;
/** emoji表情的字符 */
@property (nonatomic, copy) NSString *emoji;

- (instancetype)initEmotionWithDictionary:(NSDictionary *)dic;

@end
