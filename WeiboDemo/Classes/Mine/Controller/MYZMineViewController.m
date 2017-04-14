//
//  MYZMineViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 17/4/13.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import "MYZMineViewController.h"
#import "MYZMineChildViewController.h"

@interface MYZMineViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * controllers;
@property (nonatomic, strong) NSMutableArray * tableViews;

@property (nonatomic, strong) UIScrollView * slidePageContentScrollView;
@property (nonatomic, strong) UIView * slidePageNavBarView;
@property (nonatomic, strong) UIView * slidePageHeadBackgroundView;
@property (nonatomic, strong) UIView * slidePageHeadView;
@property (nonatomic, strong) UIView * slidePageSegmentView;

@property (nonatomic, strong) UITableView * slidePageCurrentTableView;

@end

@implementation MYZMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    //self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.slidePageContentScrollView];
    [self.view addSubview:self.slidePageHeadView];
    [self.view addSubview:self.slidePageSegmentView];
    [self.view addSubview:self.slidePageNavBarView];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.slidePageContentScrollView) { return; }
    
    NSInteger slidePageIndex = (NSInteger)scrollView.contentOffset.x/scrollView.frame.size.width;
    
    NSLog(@"scrollViewDidScroll ++** x = %.0lf y = %.0lf index = %ld", scrollView.contentOffset.x, scrollView.contentOffset.y, slidePageIndex);
    
    self.slidePageCurrentTableView = self.tableViews[slidePageIndex];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    UITableView * tableView = (UITableView *)object;
    if (tableView != self.slidePageCurrentTableView) { return; }
    
    CGFloat tableViewOffsetY = tableView.contentOffset.y;
    NSLog(@"observeValueForKeyPath ++-- %.2lf",tableViewOffsetY);
    
    CGFloat slidePageHeadH = self.slidePageHeadView.frame.size.height;
    CGFloat slidePageSegmentH = self.slidePageSegmentView.frame.size.height;
    
    CGFloat tableViewTopOffsetY = slidePageHeadH - 64;
    
    if (tableViewOffsetY >= 0 && tableViewOffsetY <= tableViewTopOffsetY) {
        
        self.slidePageNavBarView.alpha = tableViewOffsetY/tableViewTopOffsetY;
        self.slidePageHeadView.frame = CGRectMake(0, - tableViewOffsetY, SCREEN_W, slidePageHeadH);
        self.slidePageSegmentView.frame = CGRectMake(0, slidePageHeadH - tableViewOffsetY, SCREEN_W, slidePageSegmentH);
        
    } else if (tableViewOffsetY < 0) {
        
        self.slidePageNavBarView.alpha = 0.0;
        self.slidePageHeadView.frame = CGRectMake(0, -tableViewOffsetY, SCREEN_W, slidePageHeadH);
        self.slidePageSegmentView.frame = CGRectMake(0, slidePageHeadH - tableViewOffsetY, SCREEN_W, slidePageSegmentH);
        
        self.slidePageHeadBackgroundView.frame = CGRectMake(0, -50-tableViewOffsetY, SCREEN_W, self.slidePageHeadBackgroundView.frame.size.height);
        
        
    } else if (tableViewOffsetY > tableViewTopOffsetY) {
        
        self.slidePageNavBarView.alpha = 1.0;
        self.slidePageHeadView.frame = CGRectMake(0, -tableViewTopOffsetY, SCREEN_W, slidePageHeadH);
        self.slidePageSegmentView.frame = CGRectMake(0, 64, SCREEN_W, slidePageSegmentH);
    }
    
}





- (UIScrollView *)slidePageContentScrollView {
    if (_slidePageContentScrollView == nil) {
        _slidePageContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _slidePageContentScrollView.backgroundColor = [UIColor clearColor];
        
        _slidePageContentScrollView.delegate = self;
        _slidePageContentScrollView.pagingEnabled = YES;
        
        [_slidePageContentScrollView addSubview:self.slidePageHeadBackgroundView];
        
        for (int i = 0; i < 3; i++) {
            MYZMineChildViewController * slidePageTableVC = [[MYZMineChildViewController alloc] init];
            slidePageTableVC.view.frame = CGRectMake(i * SCREEN_W, 0, SCREEN_W, SCREEN_H);
            [_slidePageContentScrollView addSubview:slidePageTableVC.view];
            
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            [slidePageTableVC.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
            
            [self.controllers addObject:slidePageTableVC];
            [self.tableViews addObject:slidePageTableVC.tableView];
            
        }
        
        _slidePageContentScrollView.contentSize = CGSizeMake(SCREEN_W * self.controllers.count, 0);
        self.slidePageCurrentTableView = [self.tableViews firstObject];
        
    }
    return _slidePageContentScrollView;
}


- (UIView *)slidePageHeadBackgroundView {
    if (_slidePageHeadBackgroundView == nil) {
        _slidePageHeadBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -50, SCREEN_W, 300)];
        _slidePageHeadBackgroundView.backgroundColor = [UIColor brownColor];
    }
    return _slidePageHeadBackgroundView;
}

- (UIView *)slidePageHeadView {
    if (_slidePageHeadView == nil) {
        _slidePageHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 200)];
        _slidePageHeadView.backgroundColor = [UIColor lightGrayColor];
    }
    return _slidePageHeadView;
}

- (UIView *)slidePageSegmentView {
    if (_slidePageSegmentView == nil) {
        _slidePageSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_W, 40)];
        _slidePageSegmentView.backgroundColor = [UIColor grayColor];
    }
    return _slidePageSegmentView;
}

- (UIView *)slidePageNavBarView {
    if (_slidePageNavBarView == nil) {
        _slidePageNavBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
        _slidePageNavBarView.backgroundColor = [UIColor whiteColor];
        _slidePageNavBarView.alpha = 0.0;
    }
    return _slidePageNavBarView;
}


- (NSMutableArray *)controllers {
    if (_controllers == nil) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

- (NSMutableArray *)tableViews {
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (void)dealloc {
    
    NSLog(@"dealloc");
    
    for (UITableView * tableView in self.tableViews) {
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end
