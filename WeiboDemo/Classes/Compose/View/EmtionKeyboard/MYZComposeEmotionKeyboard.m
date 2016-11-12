//
//  MYZComposeEmotionKeyboard.m
//  WeiboDemo
//
//  Created by MA806P on 2016/10/30.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZComposeEmotionKeyboard.h"
#import "MYZEmotionListView.h"
#import "MYZEmotionToolBar.h"


CGFloat const ComposeEmotionToolBarH = 37.0; //表情键盘底部的选择表情的按钮

@interface MYZComposeEmotionKeyboard ()

/** 表情列表视图 */
@property (nonatomic, weak) MYZEmotionListView * listView;

/** 底部工具条 */
@property (nonatomic, weak) MYZEmotionToolBar * toolBar;

@end

@implementation MYZComposeEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //表情列表
        MYZEmotionListView * listView = [[MYZEmotionListView alloc] init];
        [self addSubview:listView];
        self.listView = listView;
        
        //工具条
        MYZEmotionToolBar * toolBar = [[MYZEmotionToolBar alloc] init];
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat keyBoardW = self.frame.size.width;
    CGFloat toolbarH = ComposeEmotionToolBarH;
    CGFloat toolbarY = self.frame.size.height - toolbarH;
    
    self.toolBar.frame = CGRectMake(0, toolbarY, keyBoardW, toolbarH);
    self.listView.frame = CGRectMake(0, 0, keyBoardW, toolbarY);
}




@end
