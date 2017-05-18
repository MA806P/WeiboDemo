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
    
    self.userInfoArray = @[
                           @{@"title":@"", @"subTitle":@""},
                           @{@"title":@"", @"subTitle":@""},
                           @{@"title":@"", @"subTitle":@""}
                           ];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MYZMineUserInfoCell class] forCellReuseIdentifier:@"TableViewCell"];
        
        UIView * tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_H, 242)];
        tableViewHeader.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = tableViewHeader;
        _tableView.rowHeight = 60;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(182, 0, 0, 0);
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
