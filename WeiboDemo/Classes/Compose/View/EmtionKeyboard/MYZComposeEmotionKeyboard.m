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



@interface MYZComposeEmotionKeyboard () <MYZEmotionToolBarDelegate, MYZEmotionListViewDelegate>

/** 表情列表视图 */
@property (nonatomic, weak) MYZEmotionListView * listView;

/** 底部工具条 */
@property (nonatomic, weak) MYZEmotionToolBar * toolBar;

/** 最近使用的表情数据 */
@property (nonatomic, strong) NSMutableArray * recentEmotionArray;

@end

@implementation MYZComposeEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //表情列表
        MYZEmotionListView * listView = [[MYZEmotionListView alloc] init];
        listView.delegate = self;
        __weak typeof(self) weakSelf = self;
        listView.emotionBlock = ^(MYZEmotion * emotion){
            if (weakSelf.emotionKeyboardBlock)
            {
                weakSelf.emotionKeyboardBlock(emotion);
            }
        };
        [self addSubview:listView];
        self.listView = listView;
        
        //工具条
        MYZEmotionToolBar * toolBar = [[MYZEmotionToolBar alloc] init];
        toolBar.delegate = self;
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


- (NSMutableArray *)recentEmotionArray
{
    if (_recentEmotionArray == nil)
    {
        _recentEmotionArray = [NSKeyedUnarchiver unarchiveObjectWithFile:MYZEmotionRecentDataPath];
        if (_recentEmotionArray == nil)
        {
            _recentEmotionArray = [NSMutableArray array];
        }
    }
    return _recentEmotionArray;
}


- (void)setEmotionKeyboardDataArray:(NSArray *)emotionKeyboardDataArray
{
    //_emotionKeyboardDataArray = emotionKeyboardDataArray;
    
    //觉得还是在这判断是否有最近使用的表情好点,然后一起放在大数组中，
    //从外面传来的数据没有最近使用的表情
    if (emotionKeyboardDataArray.count <= 0) { return; }
    NSMutableArray * allEmotionArray = [NSMutableArray array];
    [allEmotionArray addObject:@[self.recentEmotionArray]]; //最近使用的表情
    [allEmotionArray addObjectsFromArray:emotionKeyboardDataArray]; //默认，emoji，小浪花
    _emotionKeyboardDataArray = allEmotionArray;
    
    self.listView.emotionDataArray = _emotionKeyboardDataArray;
    
    //判断开始显示那种表情，如果最近使用的表情有数据就显示最近，否则显示默认
    if(self.recentEmotionArray.count > 0)
    {
        [self.toolBar changeSelectButtonWithType:MYZEmotionToolBarButtonTypeRecent];
        [self.listView emotionListViewShowWithType:MYZEmotionToolBarButtonTypeRecent];
    }
    else
    {
        [self.toolBar changeSelectButtonWithType:MYZEmotionToolBarButtonTypeDefault];
        [self.listView emotionListViewShowWithType:MYZEmotionToolBarButtonTypeDefault];
    }
}

#pragma mark - MYZEmotionToolBar Delegate

- (void)emotionToolBarButtonClickWithType:(MYZEmotionToolBarButtonType)btnType
{
    [self.listView emotionListViewShowWithType:btnType];
}

#pragma mark - MYZEmotionListView Delegate

- (void)emotionListScrollToType:(MYZEmotionToolBarButtonType)type
{
    [self.toolBar changeSelectButtonWithType:type];
}

@end
