//
//  MYZEmotion.m
//  WeiboDemo
//
//  Created by MA806P on 2016/11/14.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotion.h"
#import "NSString+Emoji.h"

@implementation MYZEmotion


- (instancetype)initEmotionWithDictionary:(NSDictionary *)dic
{
    if (self = [super init])
    {
        self.chs = dic[@"chs"];
        self.png = dic[@"png"];
        self.code = dic[@"code"];
        
    }
    return self;
}



/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.code = [decoder decodeObjectForKey:@"code"];
        self.directory = [decoder decodeObjectForKey:@"directory"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeObject:self.directory forKey:@"directory"];
}

- (BOOL)isEqual:(MYZEmotion *)otherEmotion
{
    if (self.code) { // emoji表情
        MYZLog(@"%@--isEqual--%@", self.code, otherEmotion.code);
        return [self.code isEqualToString:otherEmotion.code];
    } else { // 图片表情
        MYZLog(@"%@--isEqual--%@", self.chs, otherEmotion.chs);
        return [self.png isEqualToString:otherEmotion.png] && [self.chs isEqualToString:otherEmotion.chs];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ - %@", self.chs, self.png, self.code];
}

- (void)setCode:(NSString *)code
{
    _code = [code copy];
    
    if (code == nil) return;
    self.emoji = [NSString emojiWithStringCode:code];
}


@end
