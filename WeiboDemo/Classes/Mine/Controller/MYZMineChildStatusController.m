//
//  MYZMineChildStatusController.m
//  WeiboDemo
//
//  Created by MA806P on 2017/5/16.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import "MYZMineChildStatusController.h"
#import "MYZStatusFrame.h"
#import "MYZStatusCell.h"

@interface MYZMineChildStatusController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MYZMineChildStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tableView reloadData];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MYZStatusCell class] forCellReuseIdentifier:@"TableViewCell"];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        UIView * tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_H, 242)];
        tableViewHeader.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = tableViewHeader;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(182, 0, 0, 0);
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MYZStatusFrame * statusFrame = [self.dataArray objectAtIndex:indexPath.row];
    MYZStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.statusFrame = statusFrame;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYZStatusFrame * statusFrame = [self.dataArray objectAtIndex:indexPath.row];
    return statusFrame.cellHeight;
}



@end
