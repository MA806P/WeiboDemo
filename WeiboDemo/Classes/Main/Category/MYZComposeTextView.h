//
//  MYZComposeTextView.h
//  WeiboDemo
//
//  Created by MA806P on 2016/10/26.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYZEmotion;

@interface MYZComposeTextView : UITextView

@property(nonatomic, copy) NSString * placeholder;

- (void)appendEmotion:(MYZEmotion *)emotion;

@end
