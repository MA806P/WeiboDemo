//
//  MYZHomeController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//



#import "MYZHomeController.h"
#import "MYZOAuthController.h"
#import "MYZAccount.h"
#import "MYZUserInfo.h"
#import "MJRefresh.h"

#import "MYZStatus.h"
#import "MYZStatusFrame.h"
#import "MYZStatusCell.h"

NSString * const StatusCellID = @"StatusCellID";

@interface MYZHomeController ()

@property (nonatomic, strong) MYZAccount * account;
@property (nonatomic, strong) MYZUserInfo * userInfo;

@property (nonatomic, strong) NSMutableArray * statusDataArray;

@end

@implementation MYZHomeController


- (NSMutableArray *)statusDataArray
{
    if (_statusDataArray == nil)
    {
        _statusDataArray = [NSMutableArray array];
    }
    return _statusDataArray;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //判断是否授权
    self.account = [MYZTools account];
    if (self.account == nil)
    {
        [MYZTools showAlertWithText:@"用户未登录"];
        MYZOAuthController * oauthVC = [[MYZOAuthController alloc] init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:oauthVC];
        return;
    }
    
    //tableView 设置
    [self.tableView registerClass:[MYZStatusCell class] forCellReuseIdentifier:StatusCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //获取缓存的数据
    [self statusDataSortWithArray:nil];
    
    //下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新微博
        [weakSelf homeGetNewStatuses];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //加载更多微博
        [weakSelf homeGetOldStatuses];
    }];
    //self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(homeGetOldStatuses)];
    
    
    
    
}

#pragma mark - 数据处理

- (void)statusDataSortWithArray:(NSArray *)dataArray
{
    if (dataArray != nil)
    {
        [dataArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MYZStatus * status = [[MYZStatus alloc] initWithValue:obj];
            RLMRealm * realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addOrUpdateObject:status];
            [realm commitWriteTransaction];
            
        }];
    }
    
    //查询所有微博状态的结果, mid从大到小排序
    RLMResults * statusResults = [[MYZStatus allObjects] sortedResultsUsingProperty:@"mid" ascending:NO];
    [self.statusDataArray removeAllObjects];
    
    //得到微博数据模型, 转化模型计算各控件frame
    for (NSInteger i=0; i<statusResults.count; i++)
    {
        MYZStatus * status = [statusResults objectAtIndex:i];
        MYZStatusFrame * statusFrame = [MYZStatusFrame statusFrameWithStatus:status];
        [self.statusDataArray addObject:statusFrame];
    }
}



#pragma mark - 网络请求


- (void)homeGetNewStatuses
{
    /*
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     since_id	    false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	        false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	        false	int	单页返回的记录条数，最大不超过100，默认为20。
     page	        false	int	返回结果的页码，默认为1。
     base_app	    false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
     feature	    false	int	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
     trim_user	    false	int	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
     */
    MYZStatus * statusMax = [[self.statusDataArray firstObject] status];
    NSString * sinceIdStr = statusMax == nil ? @"0" : statusMax.mid;
    MYZLog(@"--- since_id = %@", sinceIdStr);
    
    int count = 100;
    
    NSDictionary * parameter = @{@"access_token":self.account.access_token, @"since_id":sinceIdStr, @"count":@(count)};
    [MYZHttpTools get:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:parameter progress:nil success:^(id response) {
        
        NSArray * statusDicts = [(NSDictionary *)response objectForKey:@"statuses"];
        
        //如果返回的微博条数等于要求返回的数,
        //可能微博较多 缓存的和刷新出来的中间还有微博, 把缓存的清理掉, 防止上拉加载更多, 中间漏掉微博
        if (statusDicts.count >= count)
        {
            [self.statusDataArray removeAllObjects];
            
            RLMRealm * realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteAllObjects];
            [realm commitWriteTransaction];
        }
        
        //数据处理排序转化
        [self statusDataSortWithArray:statusDicts];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        if (statusDicts.count > 0) {  [MYZTools showAlertWithText:[NSString stringWithFormat:@" 更新 %ld 条微博 ", statusDicts.count]]; }
        
        MYZLog(@"--- success ");
        
        
    } failure:^(NSError *error) {
        MYZLog(@"--- %@", error);
        [self.tableView.mj_header endRefreshing];
    }];
    
}


- (void)homeGetOldStatuses
{
    //max_id false	int64 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
    
    MYZStatus * statusMax = [[self.statusDataArray lastObject] status];
    //减1防止返回等于max_id的微博
    NSNumber * maxIdStr = statusMax == nil ? @(0) : @([statusMax.mid longLongValue] -1);
    MYZLog(@"--- max_id = %@", maxIdStr);
    
    NSDictionary * parameter = @{@"access_token":self.account.access_token, @"max_id":maxIdStr, @"count":@(20)};
    [MYZHttpTools get:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:parameter progress:nil success:^(id response) {
        
        NSArray * statusDicts = [(NSDictionary *)response objectForKey:@"statuses"];
        
        //数据处理排序转化
        [self statusDataSortWithArray:statusDicts];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        
        MYZLog(@"--- success ");
        
    } failure:^(NSError *error) {
        MYZLog(@"--- %@", error);
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}



#pragma mark - UITableView data sources , delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYZStatusFrame * statusFrame = [self.statusDataArray objectAtIndex:indexPath.row];
    MYZStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:StatusCellID forIndexPath:indexPath];
    cell.statusFrame = statusFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYZStatusFrame * statusFrame = [self.statusDataArray objectAtIndex:indexPath.row];
    return statusFrame.cellHeight;
}







@end