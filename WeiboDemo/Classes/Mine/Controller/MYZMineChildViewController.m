//
//  MYZMineChildViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 17/4/13.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import "MYZMineChildViewController.h"
#import "MYZMineUserInfoCell.h"
#import "MYZUserInfo.h"


FOUNDATION_EXTERN CGFloat MYZMineViewControllerSlidePageHeadViewH;
FOUNDATION_EXTERN CGFloat MYZMineViewControllerSlidePageSegmentViewH;

@interface MYZMineChildViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray * userInfoArray;

@end

@implementation MYZMineChildViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
}

- (void)setUserInfo:(MYZUserInfo *)userInfo {
    _userInfo = userInfo;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate * createDate = [dateFormatter dateFromString:_userInfo.created_at];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString * dateStr = [dateFormatter stringFromDate:createDate];
    
    self.userInfoArray = @[
                           @{@"title":@"昵称", @"subTitle":_userInfo.name},
                           @{@"title":@"性别", @"subTitle":_userInfo.gender},
                           @{@"title":@"简介", @"subTitle":_userInfo.desc},
                           @{@"title":@"注册时间", @"subTitle":dateStr}
                           ];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MYZMineUserInfoCell class] forCellReuseIdentifier:@"TableViewCell"];
        
        //UIView * tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_H, MYZMineViewControllerSlidePageHeadViewH+MYZMineViewControllerSlidePageSegmentViewH)];
        //tableViewHeader.backgroundColor = [UIColor clearColor];
        //_tableView.tableHeaderView = tableViewHeader;
        //_tableView.scrollIndicatorInsets = UIEdgeInsetsMake(182, 0, 0, 0);
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MYZMineUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.dict = self.userInfoArray[indexPath.row];
    return cell;
}



@end
