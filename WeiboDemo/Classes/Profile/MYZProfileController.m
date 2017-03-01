//
//  MYZProfileController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZProfileController.h"
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

static NSString * const CellId = @"CellId";
static CGFloat alpha = 0;
static CGFloat const headerH = 180.0;
static CGFloat const AngleScale = 2.0 * M_PI / 180.0;

static NSString * const IndicatorAnimationKey = @"IndicatorAnimationKey";
static NSString * const ProfileStatusCellID = @"ProfileStatusCellID";

@interface MYZProfileController ()<MYZStatusCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView * tableView;

@property (nonatomic, assign) BOOL isChangeStatusBar;

@property (nonatomic, weak) UIImageView * headerBgImageView;
@property (nonatomic, weak) UIImageView * indicatorImgView;
@property (nonatomic, strong) CABasicAnimation * rotateAnimation;

@property (nonatomic, strong) MYZAccount * account;
@property (nonatomic, strong) MYZUserInfo * userInfo;
@property (nonatomic, weak) UIImageView * avator;
@property (nonatomic, weak) UILabel * nameLabel;
@property (nonatomic, weak) UILabel * numberLabel;
@property (nonatomic, weak) UILabel * descrLabel;

@property (nonatomic, strong) RLMRealm * realm;

@property (nonatomic, assign) BOOL userInfoIsLoading;
@property (nonatomic, assign) BOOL userTimeLineIsLoading;

/** 我发的微博数据 */
@property (nonatomic, strong) NSMutableArray * statusDataArray;

@end

@implementation MYZProfileController

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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self scrollViewDidScroll:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MYZStatusCell class] forCellReuseIdentifier:ProfileStatusCellID];
    
    //头部用户视图的数据设置
    if (self.userInfo)
    {
        [self refreshHeaderViewData];
    }
    else
    {
        [self requestHeaderViewUserInfo];
    }
    
    //我的微博数据
    if (self.statusDataArray.count == 0)
    {
        [self requestUserTimeLine];
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //设置当有导航栏自动添加64的高度的属性为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 46, 0);
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellId];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //设置tableView的头部视图
    UIView * tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, headerH)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerH)];
    imageView.image = [UIImage imageNamed:@"11"];
    [self.tableView addSubview:imageView];
    self.headerBgImageView = imageView;
    
    CGFloat avatorH = 50;
    CGFloat avatorY = headerH*0.5 - avatorH;
    UIImageView * avator = [[UIImageView alloc] initWithFrame:CGRectMake(0, avatorY, SCREEN_W, avatorH)];
    avator.contentMode = UIViewContentModeScaleAspectFit;
    [self.tableView addSubview:avator];
    self.avator = avator;
    
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.avator.frame)+10, SCREEN_W, 20)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+3, SCREEN_W, 20)];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:13];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    UILabel * descrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame)+3, SCREEN_W, 20)];
    descrLabel.textColor = [UIColor whiteColor];
    descrLabel.font = [UIFont systemFontOfSize:12];
    descrLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:descrLabel];
    self.descrLabel = descrLabel;
    
    UIImageView * indicatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicator"]];
    indicatorImgView.frame = CGRectMake(20, 30, 25, 25);
    indicatorImgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:indicatorImgView];
    self.indicatorImgView = indicatorImgView;
    
    self.rotateAnimation = [[CABasicAnimation alloc] init];
    self.rotateAnimation.keyPath = @"transform.rotation.z";
    self.rotateAnimation.fromValue = @0;
    self.rotateAnimation.toValue = @(M_PI * 2);
    self.rotateAnimation.duration = 0.5;
    self.rotateAnimation.repeatCount = MAXFLOAT;
    
    
    
}

- (void)requestHeaderViewUserInfo
{
    //获取用户信息
    NSDictionary * showParameter = @{@"access_token":self.account.access_token,@"uid":self.account.uid};
    [MYZHttpTools get:@"https://api.weibo.com/2/users/show.json" parameters:showParameter progress:^(NSProgress *progress) {
    } success:^(id response) {
        NSDictionary * userInfoDic = (NSDictionary *)response;
        self.userInfo = [[MYZUserInfo alloc] initWithValue:userInfoDic];
        [self refreshHeaderViewData];
        
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:self.userInfo];
        [realm commitWriteTransaction];
        
        self.userInfoIsLoading = NO;
        if (self.userTimeLineIsLoading == NO) {
            [self headIndicatorEndRefreshing];
        }
        
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
    }];
}

- (void)refreshHeaderViewData
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
        [self.tableView reloadData];
        
        //[SVProgressHUD dismiss];
        self.userTimeLineIsLoading = NO;
        if (self.userInfoIsLoading == NO) {
            [self headIndicatorEndRefreshing];
        }
        
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
        [SVProgressHUD dismiss];
    }];
    
    
    
    
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYZStatusFrame * statusFrame = [self.statusDataArray objectAtIndex:indexPath.row];
    MYZStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:ProfileStatusCellID forIndexPath:indexPath];
    cell.statusFrame = statusFrame;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYZStatusFrame * statusFrame = [self.statusDataArray objectAtIndex:indexPath.row];
    return statusFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYZStatusFrame * statusFrame = [self.statusDataArray objectAtIndex:indexPath.row];
    
    MYZStatusViewController * statusVC = [[MYZStatusViewController alloc] init];
    statusVC.statusFrame = statusFrame;
    [self.navigationController pushViewController:statusVC animated:YES];
}

#pragma mark - UIScrollView delegate

BOOL StartedLoading;
CGFloat CurrentOffsetY = 0;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    StartedLoading = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    if (offsetY < 0)
    {
        CGFloat headerW = screenW - offsetY;
        CGFloat headerX = (screenW - headerW) * 0.5;
        self.headerBgImageView.frame = CGRectMake(headerX, offsetY, headerW, headerH-offsetY);
        
        if (StartedLoading == NO)
        {
            self.indicatorImgView.hidden = NO;
            self.indicatorImgView.transform = CGAffineTransformRotate(self.indicatorImgView.transform, (offsetY-CurrentOffsetY)*AngleScale);
        }
        CurrentOffsetY = offsetY;
        
    }
    else if (offsetY >= 0)
    {
        self.headerBgImageView.frame = CGRectMake(0, 0, screenW, headerH);
        if (StartedLoading == NO) { self.indicatorImgView.hidden = YES; }
    }
    
    alpha =  offsetY/headerH;
    alpha = (alpha <= 0)?0:alpha;
    alpha = (alpha >= 1)?1:alpha;
    
    UIColor * titleColor;
    
    if (alpha > 0.6)
    {
        self.isChangeStatusBar = YES;
        titleColor = [UIColor blackColor];
    }
    else
    {
        self.isChangeStatusBar = NO;
        titleColor = [UIColor whiteColor];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    //设置导航条上的标签是否跟着透明
    //self.navigationItem.leftBarButtonItem.customView.alpha = alpha;
    //self.navigationItem.rightBarButtonItem.customView.alpha = alpha;
    //self.navigationItem.titleView.alpha = alpha;
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[titleColor colorWithAlphaComponent:alpha]};
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (-offsetY > 60 && StartedLoading == NO)
    {
        StartedLoading = YES;
        [self.indicatorImgView.layer addAnimation:self.rotateAnimation forKey:IndicatorAnimationKey];
        
        self.userInfoIsLoading = YES;
        [self requestHeaderViewUserInfo];
        self.userTimeLineIsLoading = YES;
        [self requestUserTimeLine];
    }
}

//停止加载转圈的动画, 并隐藏
- (void)headIndicatorEndRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        StartedLoading = NO;
        [self.indicatorImgView.layer removeAnimationForKey:IndicatorAnimationKey];
        self.indicatorImgView.transform = CGAffineTransformIdentity;
        self.indicatorImgView.hidden = YES;
        
    });
    
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.isChangeStatusBar)
    {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}


#pragma mark - MYZStatusCellDelegate 点击事件, 正文连接 评论 转发 点赞

//点击微博正文能点的地方
- (void)statusTouchTextLinkWithTextItem:(MYZStatusTextItem *)linkTextItem statusFrame:(MYZStatusFrame *)statusFrame
{
    if (linkTextItem.type == StatusTextItemTypeUrl)
    {
        NSString * linkString = linkTextItem.text;
        if ([linkString hasPrefix:@"http://m.weibo.cn"])
        {
            if (statusFrame)
            {
                MYZStatusViewController * statusVC = [[MYZStatusViewController alloc] init];
                statusVC.statusFrame = statusFrame;
                [self.navigationController pushViewController:statusVC animated:YES];
            }
        }
        else
        {
            //点击微博中链接，跳转网页
            MYZWebViewController * webViewController = [[MYZWebViewController alloc] init];
            webViewController.urlString = linkString;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
    }
}

//点击转发微博
- (void)statusTouchRepostWithStatus:(MYZStatusFrame *)statusFrame
{
    MYZStatusOriginal * status = statusFrame.status;
    if (status)
    {
        MYZComposeController * compose = [[MYZComposeController alloc] init];
        compose.composeType = ComposeTypeRepost;
        compose.status = status;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:compose];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

//点击评论
- (void)statusTouchCommentWithStatus:(MYZStatusFrame *)statusFrame
{
    MYZStatusViewController * statusVC = [[MYZStatusViewController alloc] init];
    statusVC.statusFrame = statusFrame;
    statusVC.type = StatusViewControllerTypeComment;
    [self.navigationController pushViewController:statusVC animated:YES];
}

////点赞
//- (void)statusTouchLikeWithStatus:(MYZStatusFrame *)statusFrame
//{
//    
//}

@end
