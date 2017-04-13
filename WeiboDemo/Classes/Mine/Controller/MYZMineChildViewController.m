//
//  MYZMineChildViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 17/4/13.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import "MYZMineChildViewController.h"

@interface MYZMineChildViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MYZMineChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
        
        UIView * tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_H, 242)];
        tableViewHeader.backgroundColor = [UIColor brownColor];
        _tableView.tableHeaderView = tableViewHeader;
        _tableView.rowHeight = 60;
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(182, 0, 0, 0);
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"-- %ld",indexPath.row];
    return cell;
}



@end
