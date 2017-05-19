//
//  MYZMineViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 17/4/13.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import "MYZMineViewController.h"
#import "MYZMineChildViewController.h"
#import "MYZMineChildStatusController.h"
#import "MYZOAuthController.h"
#import "WeiboSDK.h"
#import "MYZUserInfo.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusFrame.h"
#import "MYZStatusCell.h"
#import "MYZStatusViewController.h"
#import "MYZWebViewController.h"
#import "MYZComposeController.h"
#import "MYZStatusTextItem.h"


static CGFloat kMineSlidePageHeadViewH = 200.0;
static CGFloat kMineSlidePageSegmentViewH = 40.0;


@interface MYZMineViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray * controllers;
@property (nonatomic, strong) NSMutableArray * tableViews;

@property (nonatomic, strong) UIScrollView * slidePageContentScrollView;
@property (nonatomic, strong) UIView * slidePageNavBarView;
@property (nonatomic, strong) UIView * slidePageHeadBackgroundView;
@property (nonatomic, strong) UIView * slidePageHeadView;
@property (nonatomic, strong) UIView * slidePageSegmentView;

@property (nonatomic, strong) UITableView * slidePageCurrentTableView;


@property (nonatomic, strong) MYZAccount * account;
@property (nonatomic, strong) MYZUserInfo * userInfo;
@property (nonatomic, strong) RLMRealm * realm;
/** 我发的微博数据 */
@property (nonatomic, strong) NSMutableArray * statusDataArray;


@property (nonatomic, weak) UIImageView * headerBgImageView;
@property (nonatomic, weak) UIImageView * avator;
@property (nonatomic, weak) UILabel * nameLabel;
@property (nonatomic, weak) UILabel * numberLabel;
@property (nonatomic, weak) UILabel * descrLabel;


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
    
    
    //头部用户视图的数据设置
    if (self.userInfo) {
        [self resetHeaderViewData];
        
        MYZMineChildViewController * slidePageTable0VC = self.controllers[0];
        slidePageTable0VC.userInfo = self.userInfo;
        
        
    } else {
        [self requestHeaderViewUserInfo];
    }
    
    //我的微博数据
    if (self.statusDataArray.count > 0) {
        
        MYZMineChildStatusController * slidePageTable1VC = self.controllers[1];
        slidePageTable1VC.dataArray = self.statusDataArray;
        
    } else {
        [self requestUserTimeLine];
    }
}

#pragma mark - UI data


- (MYZAccount *)account
{
    if (_account == nil)
    {
        //判断是否授权
        MYZAccount * account = [MYZTools account];
        if (account == nil)
        {
            [MYZTools showAlertWithText:@"用户未登录"];
            return nil;
        }
        _account = account;
    }
    return _account;
}

- (MYZUserInfo *)userInfo
{
    if (_userInfo == nil)
    {
        //从数据库中查询是否有用户数据
        RLMResults<MYZUserInfo *> *userInfo = [MYZUserInfo objectsWhere:@"idstr = %@",self.account.uid];
        if (userInfo.count <= 0)
        {
            return nil;
        }
        _userInfo = (MYZUserInfo *)[userInfo firstObject];
    }
    return _userInfo;
}

- (NSMutableArray *)statusDataArray
{
    if (_statusDataArray == nil)
    {
        _statusDataArray = [NSMutableArray array];
        
        RLMResults * statusResults = [[MYZStatusOriginal allObjectsInRealm:self.realm] sortedResultsUsingProperty:@"mid" ascending:NO];
        
        //得到微博数据模型, 转化模型计算各控件frame
        for (NSInteger i=0; i<statusResults.count; i++)
        {
            MYZStatusOriginal * status = [statusResults objectAtIndex:i];
            MYZStatusFrame * statusFrame = [MYZStatusFrame statusFrameWithStatus:status];
            [_statusDataArray addObject:statusFrame];
        }
    }
    return _statusDataArray;
}


- (RLMRealm *)realm
{
    if (_realm == nil)
    {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [path stringByAppendingPathComponent:@"profile.realm"];
        //NSLog(@"数据库目录 = %@",filePath);
        
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        config.fileURL = [NSURL URLWithString:filePath];
        
        //config.objectClasses = @[MYZStatusOriginal.class];
        //config.readOnly = NO;
        
        RLMRealm * realm = [RLMRealm realmWithConfiguration:config error:nil];
        _realm = realm;
    }
    return _realm;
}


- (void)requestHeaderViewUserInfo
{
    //获取用户信息
    NSDictionary * showParameter = @{@"access_token":self.account.access_token,@"uid":self.account.uid};
    [MYZHttpTools get:@"https://api.weibo.com/2/users/show.json" parameters:showParameter progress:^(NSProgress *progress) {
    } success:^(id response) {
        NSDictionary * userInfoDic = (NSDictionary *)response;
        self.userInfo = [[MYZUserInfo alloc] initWithValue:userInfoDic];
        //[self refreshHeaderViewData];
        
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:self.userInfo];
        [realm commitWriteTransaction];
        
        MYZMineChildViewController * slidePageTable0VC = self.controllers[1];
        slidePageTable0VC.userInfo = self.userInfo;
        
        //self.userInfoIsLoading = NO;
        //if (self.userTimeLineIsLoading == NO) {
        //    [self headIndicatorEndRefreshing];
        //}
        
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
    }];
}


- (void)resetHeaderViewData
{
    [self.headerBgImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.cover_image_phone]];
    [self.avator sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar_large] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.avator.image = [UIImage myz_imageWithCircleClipImage:image];
    }];
    self.nameLabel.text = self.userInfo.name;
    self.numberLabel.text = [NSString stringWithFormat:@"关注  %ld   |   粉丝  %ld", self.userInfo.friends_count, self.userInfo.followers_count];
    self.descrLabel.text = self.userInfo.desc;
}

- (void)requestUserTimeLine
{
    
    //用户最新发表的微博列表
    /*
     screen_name	false	string	需要查询的用户昵称。
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     count	false	int	单页返回的记录条数，最大不超过100，超过100以100处理，默认为20。
     page	false	int	返回结果的页码，默认为1。
     base_app	false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
     feature	false	int	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
     trim_user	false	int	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
     */
    
    //[SVProgressHUD show];
    
    NSDictionary * userTimelineParameter = @{@"access_token":self.account.access_token,@"uid":self.account.uid};
    [MYZHttpTools get:@"https://api.weibo.com/2/statuses/user_timeline.json" parameters:userTimelineParameter progress:^(NSProgress *progress) {
    } success:^(id response) {
        //NSDictionary * userTimelineDic = (NSDictionary *)response;
        //MYZLog(@" --- %@ ", userTimelineDic);
        
        NSArray * statusDicts = [(NSDictionary *)response objectForKey:@"statuses"];
        [self.statusDataArray removeAllObjects];
        for (NSDictionary * tempDic in statusDicts)
        {
            MYZStatusOriginal * status = [[MYZStatusOriginal alloc] initWithValue:tempDic];
            MYZStatusFrame * statusFrame = [MYZStatusFrame statusFrameWithStatus:status];
            [self.statusDataArray addObject:statusFrame];
            
            //存入数据库
            [self.realm beginWriteTransaction];
            [self.realm addOrUpdateObject:status];
            [self.realm commitWriteTransaction];
            
        }
        //[self.tableView reloadData];
        
        MYZMineChildStatusController * slidePageTable1VC = self.controllers[1];
        slidePageTable1VC.dataArray = self.statusDataArray;
        
        //[SVProgressHUD dismiss];
        //self.userTimeLineIsLoading = NO;
        //if (self.userInfoIsLoading == NO) {
        //    [self headIndicatorEndRefreshing];
        //}
        
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
        [SVProgressHUD dismiss];
    }];
    
    
    
    
    
    
    
}



#pragma mark - UI Control


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.slidePageContentScrollView) { return; }
    
    NSInteger slidePageIndex = (NSInteger)scrollView.contentOffset.x/scrollView.frame.size.width;
    
    //NSLog(@"scrollViewDidScroll ++** x = %.0lf y = %.0lf index = %ld", scrollView.contentOffset.x, scrollView.contentOffset.y, slidePageIndex);
    
    self.slidePageCurrentTableView = self.tableViews[slidePageIndex];
    //NSLog(@"--** %@", NSStringFromCGPoint(self.slidePageCurrentTableView.contentOffset));
    //self.slidePageCurrentTableView.contentOffset = CGPointZero;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    UITableView * tableView = (UITableView *)object;
    if (tableView != self.slidePageCurrentTableView) { return; }
    
    CGFloat tableViewOffsetY = tableView.contentOffset.y;
    
    
    CGFloat slidePageHeadH = self.slidePageHeadView.frame.size.height;
    CGFloat slidePageSegmentH = self.slidePageSegmentView.frame.size.height;
    
    CGFloat tableViewTopOffsetY = slidePageHeadH - 64;
    
    //NSLog(@"observeValueForKeyPath ++--  %.2lf %.2lf",tableViewTopOffsetY, tableViewOffsetY);
    
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
    
    
    
    for (UITableView * tempTableView in self.tableViews) {
        
        if (tableView == tempTableView || tempTableView.contentOffset.y >= tableViewTopOffsetY ) { continue; }
        
        
        if (tableViewOffsetY > 0 && tableViewOffsetY < tableViewTopOffsetY ) {
            tempTableView.contentOffset = CGPointMake(0, tableViewOffsetY);
        }
    }
    
    
    
}



#pragma mark - UI init

- (UIScrollView *)slidePageContentScrollView {
    if (_slidePageContentScrollView == nil) {
        _slidePageContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _slidePageContentScrollView.backgroundColor = [UIColor clearColor];
        
        _slidePageContentScrollView.delegate = self;
        _slidePageContentScrollView.pagingEnabled = YES;
        
        [_slidePageContentScrollView addSubview:self.slidePageHeadBackgroundView];
        
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        
        MYZMineChildViewController * slidePageTableVC = [[MYZMineChildViewController alloc] init];
        slidePageTableVC.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [_slidePageContentScrollView addSubview:slidePageTableVC.view];
        [slidePageTableVC.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
        [self.controllers addObject:slidePageTableVC];
        [self.tableViews addObject:slidePageTableVC.tableView];
        
        
        MYZMineChildStatusController * slidePageTable1VC = [[MYZMineChildStatusController alloc] init];
        slidePageTable1VC.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H);
        [_slidePageContentScrollView addSubview:slidePageTable1VC.view];
        [slidePageTable1VC.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
        [self.controllers addObject:slidePageTable1VC];
        [self.tableViews addObject:slidePageTable1VC.tableView];
        
            
        
//        MYZMineChildViewController * slidePageTable2VC = [[MYZMineChildViewController alloc] init];
//        slidePageTable2VC.view.frame = CGRectMake(2 * SCREEN_W, 0, SCREEN_W, SCREEN_H);
//        [_slidePageContentScrollView addSubview:slidePageTable2VC.view];
//        [slidePageTable2VC.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
//        [self.controllers addObject:slidePageTable2VC];
//        [self.tableViews addObject:slidePageTable2VC.tableView];
        
        
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
        _slidePageHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, kMineSlidePageHeadViewH)];
        _slidePageHeadView.backgroundColor = [UIColor lightGrayColor];
        
        
        
        //头部视图
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, kMineSlidePageHeadViewH)];
        imageView.image = [UIImage imageNamed:@"11"];
        [_slidePageHeadView addSubview:imageView];
        self.headerBgImageView = imageView;
        
        CGFloat avatorH = 50;
        CGFloat avatorY = kMineSlidePageHeadViewH*0.5 - avatorH;
        UIImageView * avator = [[UIImageView alloc] initWithFrame:CGRectMake(0, avatorY, SCREEN_W, avatorH)];
        avator.contentMode = UIViewContentModeScaleAspectFit;
        [_slidePageHeadView addSubview:avator];
        self.avator = avator;
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.avator.frame)+10, SCREEN_W, 20)];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_slidePageHeadView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+3, SCREEN_W, 20)];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = [UIFont systemFontOfSize:13];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [_slidePageHeadView addSubview:numberLabel];
        self.numberLabel = numberLabel;
        
        UILabel * descrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame)+3, SCREEN_W, 20)];
        descrLabel.textColor = [UIColor whiteColor];
        descrLabel.font = [UIFont systemFontOfSize:12];
        descrLabel.textAlignment = NSTextAlignmentCenter;
        [_slidePageHeadView addSubview:descrLabel];
        self.descrLabel = descrLabel;
        
        
    }
    return _slidePageHeadView;
}

- (UIView *)slidePageSegmentView {
    if (_slidePageSegmentView == nil) {
        _slidePageSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, kMineSlidePageHeadViewH, SCREEN_W, kMineSlidePageSegmentViewH)];
        
        //UIButton * zhuyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //zhuyeBtn.frame = CGRectMake(0, 0, <#CGFloat width#>, kMineSlidePageSegmentViewH)
        
        
        
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
    
    //NSLog(@"dealloc");
    
    for (UITableView * tableView in self.tableViews) {
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end
