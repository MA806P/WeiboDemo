//
//  MYZMenuView.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/21.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZMenuView.h"

@interface MYZMenuView ()

@property (nonatomic, copy) NSArray * titlesArray;

@property (nonatomic, strong) NSMutableArray * buttonArray;

@property (nonatomic, weak) UIButton * selectedBtn;

@property (nonatomic, weak) UIView * indexLineView;

@end

@implementation MYZMenuView

- (NSMutableArray *)buttonArray
{
    if (_buttonArray == nil)
    {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame])
    {
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
        
        //要显示的标题数组,标题字符串
        self.titlesArray = titles;
        
        //创建子视图
        [self createSubViews];
    }
    return self;
}



- (void)createSubViews
{
    
    
    //菜单按钮
    CGFloat menuW = self.frame.size.width;
    NSInteger menuSubVCCount = self.titlesArray.count;
    
    CGFloat menuBtnW = menuSubVCCount > ActitvityMenuShowCount ? menuW/(ActitvityMenuShowCount*1.0) : menuW / (menuSubVCCount*1.0);
    for (int i = 0; i < menuSubVCCount; i++)
    {
        CGFloat menuBtnX = i * menuBtnW;
        UIButton * menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        menuBtn.frame = CGRectMake(menuBtnX, 0, menuBtnW, ActivityMenuHeight);
        [menuBtn setTitle:self.titlesArray[i] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        menuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        menuBtn.tag = i;
        [menuBtn addTarget:self action:@selector(menuBtnTouchSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
        
        //默认选中第一个
        if(i==0)
        {
            menuBtn.selected = YES;
            self.selectedBtn = menuBtn;
        }
        
        [self.buttonArray addObject:menuBtn];
    }
    
    //底部的指示线, 随着选中而移动
    CGFloat indexLineH = 3.0;
    CGFloat indexLineY = ActivityMenuHeight - indexLineH;
    UIView * indexLineView = [[UIView alloc] initWithFrame:CGRectMake(0, indexLineY, menuBtnW, indexLineH)];
    indexLineView.backgroundColor = [UIColor redColor];
    [self addSubview:indexLineView];
    self.indexLineView = indexLineView;
    
    //设置contentSize
    CGFloat contentW = menuSubVCCount * menuBtnW;
    self.contentSize = CGSizeMake(contentW, ActivityMenuHeight);
    
    
    //底部分隔线
    
    CGFloat lineH = 1.0/[UIScreen mainScreen].scale;
    CGFloat lineY = ActivityMenuHeight - lineH;
    UIView * separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, contentW, lineH)];
    separateLine.backgroundColor = [UIColor redColor];
    [self addSubview:separateLine];
    
}


- (void)menuBtnTouchSelected:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    //移动指示线
    CGRect indexLineFrame = self.indexLineView.frame;
    indexLineFrame.origin.x = btn.tag*1.0 * CGRectGetWidth(btn.frame);
    [UIView animateWithDuration:0.3 animations:^{
        self.indexLineView.frame = indexLineFrame;
    }];
    
}


@end
