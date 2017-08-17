//
//  MYZMineViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 17/4/13.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import "MYZMineViewController.h"
#import "MYZOAuthController.h"
#import "WeiboSDK.h"
#import "MYZUserInfo.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusFrame.h"
#import "MYZStatusCell.h"
#import "MYZMineUserInfoCell.h"
#import "MYZStatusViewController.h"
#import "MYZWebViewController.h"
#import "MYZComposeController.h"
#import "MYZStatusTextItem.h"
#import "UIView+MYZ.h"
#import "MYZDynamicItem.h"


static CGFloat const MYZMineViewControllerSlidePageHeadViewH = 170.0;
static CGFloat const MYZMineViewControllerSlidePageSegmentViewH = 40.0;

static NSString * const kMineInfoCellId = @"kMineInfoCellId";
static NSString * const kMineStatusCellId = @"kMineStatusCellId";

@interface MYZMineViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray * tableViews;

@property (nonatomic, strong) UIScrollView * slidePageMainScrollView;
@property (nonatomic, strong) UIScrollView * slidePageContentScrollView;
@property (nonatomic, strong) UIView * slidePageNavBarView;
//@property (nonatomic, strong) UIImageView * slidePageHeadBackgroundView;
@property (nonatomic, strong) UIView * slidePageHeadView;
@property (nonatomic, strong) UIView * slidePageSegmentView;
@property (nonatomic, strong) NSArray * slidePageSegmentBtnArray;
@property (nonatomic, strong) UITableView * slidePageCurrentTableView;
@property (nonatomic, weak) UIView * slidePageSegmentLine;

@property (nonatomic, strong) MYZAccount * account;
@property (nonatomic, strong) MYZUserInfo * userInfo;
@property (nonatomic, strong) RLMRealm * realm;

/** 我发的微博数据 */
@property (nonatomic, strong) NSMutableArray * statusDataArray;
/** 我的个人信息的数据 */
@property (nonatomic, strong) NSMutableArray * infoDataArray;


@property (nonatomic, weak) UIImageView * headerBgImageView;
@property (nonatomic, weak) UIImageView * avator;
@property (nonatomic, weak) UILabel * nameLabel;
@property (nonatomic, weak) UILabel * numberLabel;
@property (nonatomic, weak) UILabel * descrLabel;


@property (nonatomic, weak) UITableView * mineInfoTableView;
@property (nonatomic, weak) UITableView * mineStatusTableView;

@property (nonatomic, strong) MYZDynamicItem * dynamicItem;
@property (nonatomic, strong) UIDynamicAnimator * animator;


@end

@implementation MYZMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
    [self.animator removeAllBehaviors];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.slidePageNavBarView];
    [self.view addSubview:self.slidePageMainScrollView];
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.dynamicItem = [[MYZDynamicItem alloc] init];
    
    //头部用户视图的数据设置
    if (self.userInfo) {
        [self resetHeaderViewData];
        
        [self.infoDataArray removeAllObjects];
        [self.infoDataArray addObjectsFromArray:[self resetMineInfoDataWithUserInfo:self.userInfo]];
        [self.mineInfoTableView reloadData];
    } else {
        [self requestHeaderViewUserInfo];
    }
    
    //我的微博数据
    if (self.statusDataArray.count > 0) {
        [self.mineStatusTableView reloadData];
    } else {
        [self requestUserTimeLine];
    }
}



#pragma mark - UI Control


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    /** 控制手势是否能够同时响应。
     *  gestureRecognizer手动加在self.view上的pan手势。
     *  otherGestureRecognizer srollview上自己的手势UIScrollViewPanGestureRecognizer
     *  当左右滑动时允许同时响应 return yes;
     *  当上下滑动时只允许gestureRecognizer响应 return no;
     */
    
    NSLog(@"****** %@  %@", [gestureRecognizer class], [otherGestureRecognizer class]);
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGFloat currentY = [recognizer translationInView:self.view].y;
        CGFloat currentX = [recognizer translationInView:self.view].x;
        
        if (currentY == 0.0) {
            NSLog(@"***** 1");
            return YES;
        } else {
            if (fabs(currentX)/currentY >= 5.0) {
                NSLog(@"***** 2");
                return YES;
            } else {
                NSLog(@"***** 3");
                return NO;
            }
        }
    }
    NSLog(@"***** 4");
    return NO;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recongnizer {
    
    NSLog(@"===== panGestureRecognizerAction");
    
}


#pragma mark - event action

- (void)slideSegmentBtnTouchAction:(UIButton *)btn {
    
    for (UIButton * btn in self.slidePageSegmentBtnArray) {
        btn.selected = NO;
    }
    btn.selected = YES;
    
    NSInteger btnIndex = [self.slidePageSegmentBtnArray indexOfObject:btn];
    [UIView animateWithDuration:0.5 animations:^{
        self.slidePageContentScrollView.contentOffset = CGPointMake(SCREEN_W*btnIndex, 0);
    }];
}


#pragma mrak - table view deleage datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mineInfoTableView) {
        return self.infoDataArray.count;
    } else if (tableView == self.mineStatusTableView) {
        return self.statusDataArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.mineInfoTableView) {
        MYZMineUserInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:kMineInfoCellId forIndexPath:indexPath];
        cell.dict = self.infoDataArray[indexPath.row];
        return cell;
    } else if (tableView == self.mineStatusTableView) {
        MYZStatusFrame * statusFrame = [self.statusDataArray objectAtIndex:indexPath.row];
        MYZStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:kMineStatusCellId forIndexPath:indexPath];
        cell.statusFrame = statusFrame;
        return cell;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mineInfoTableView) {
        return 60;
    } else if (tableView == self.mineStatusTableView) {
        MYZStatusFrame * statusFrame = [self.statusDataArray objectAtIndex:indexPath.row];
        return statusFrame.cellHeight;
    } else {
        return 0;
    }
}



#pragma mark - UI init

- (UIScrollView *)slidePageMainScrollView {
    if (_slidePageMainScrollView == nil) {
        _slidePageMainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_W, SCREEN_H-64)];
        _slidePageMainScrollView.delegate = self;
        _slidePageMainScrollView.scrollEnabled = NO;
        
        [_slidePageMainScrollView addSubview:self.slidePageHeadView];
        [_slidePageMainScrollView addSubview:self.slidePageSegmentView];
        [_slidePageMainScrollView addSubview:self.slidePageContentScrollView];
    }
    return _slidePageMainScrollView;
}

- (UIScrollView *)slidePageContentScrollView {
    if (_slidePageContentScrollView == nil) {
        
        CGFloat contentH = SCREEN_H-MYZMineViewControllerSlidePageSegmentViewH-64;
        _slidePageContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MYZMineViewControllerSlidePageHeadViewH+MYZMineViewControllerSlidePageSegmentViewH, SCREEN_W, contentH)];
        
        _slidePageContentScrollView.delegate = self;
        _slidePageContentScrollView.pagingEnabled = YES;
        
        
        UITableView * mineInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, contentH) style:UITableViewStylePlain];
        mineInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mineInfoTableView.delegate = self;
        mineInfoTableView.dataSource = self;
        [mineInfoTableView registerClass:[MYZMineUserInfoCell class] forCellReuseIdentifier:kMineInfoCellId];
        [_slidePageContentScrollView addSubview:mineInfoTableView];
        self.mineInfoTableView = mineInfoTableView;
        [self.tableViews addObject:self.mineInfoTableView];
        
        UITableView * mineStatusTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.mineInfoTableView.frame), 0, SCREEN_W, contentH) style:UITableViewStylePlain];
        mineStatusTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mineStatusTableView.delegate = self;
        mineStatusTableView.dataSource = self;
        [mineStatusTableView registerClass:[MYZStatusCell class] forCellReuseIdentifier:kMineStatusCellId];
        [_slidePageContentScrollView addSubview:mineStatusTableView];
        self.mineStatusTableView = mineStatusTableView;
        [self.tableViews addObject:self.mineStatusTableView];
        
        
        _slidePageContentScrollView.contentSize = CGSizeMake(SCREEN_W * self.tableViews.count, contentH);
        _slidePageContentScrollView.contentOffset = CGPointMake(SCREEN_W, 0);
        self.slidePageCurrentTableView = [self.tableViews lastObject];
        
    }
    return _slidePageContentScrollView;
}


//- (UIImageView *)slidePageHeadBackgroundView {
//    if (_slidePageHeadBackgroundView == nil) {
//        _slidePageHeadBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -50, SCREEN_W, 300)];
//        _slidePageHeadBackgroundView.image = [UIImage imageNamed:@"11"];
//    }
//    return _slidePageHeadBackgroundView;
//}

- (UIView *)slidePageHeadView {
    if (_slidePageHeadView == nil) {
        _slidePageHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, MYZMineViewControllerSlidePageHeadViewH)];
        _slidePageHeadView.backgroundColor = [UIColor lightGrayColor];
        
        
        CGFloat avatorH = 50;
        CGFloat avatorY = MYZMineViewControllerSlidePageHeadViewH*0.5 - avatorH;
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
        _slidePageSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, MYZMineViewControllerSlidePageHeadViewH, SCREEN_W, MYZMineViewControllerSlidePageSegmentViewH)];
        _slidePageSegmentView.backgroundColor = [UIColor whiteColor];
        
        UIView * seperatorLineT = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 1.0)];
        seperatorLineT.backgroundColor = [UIColor lightGrayColor];
        [_slidePageSegmentView addSubview:seperatorLineT];
        UIView * seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, MYZMineViewControllerSlidePageSegmentViewH-1.0, SCREEN_W, 1.0)];
        seperatorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
        [_slidePageSegmentView addSubview:seperatorLine];
        
        
        CGFloat btnH = MYZMineViewControllerSlidePageSegmentViewH;
        CGFloat btnMargin = 20;
        UIFont * btnFont = [UIFont systemFontOfSize:14];
        
        
        NSString * zhuyeBtnTitle = @"主页";
        CGFloat btn1W = [zhuyeBtnTitle sizeWithAttributes:@{NSFontAttributeName:btnFont}].width;
        CGFloat btn1X = SCREEN_W * 0.5 - btn1W - btnMargin;
        
        UIButton * zhuyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        zhuyeBtn.frame = CGRectMake(btn1X, 0, btn1W, btnH);
        [zhuyeBtn setTitle:zhuyeBtnTitle forState:UIControlStateNormal];
        zhuyeBtn.titleLabel.font = btnFont;
        [zhuyeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [zhuyeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [zhuyeBtn addTarget:self action:@selector(slideSegmentBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_slidePageSegmentView addSubview:zhuyeBtn];
        
        
        
        NSString * weiboBtnTitle = @"主页";
        CGFloat btn2W = [weiboBtnTitle sizeWithAttributes:@{NSFontAttributeName:btnFont}].width;
        CGFloat btn2X = SCREEN_W * 0.5 + btnMargin;
        
        UIButton * weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        weiboBtn.frame = CGRectMake(btn2X, 0, btn2W, btnH);
        [weiboBtn setTitle:@"微博" forState:UIControlStateNormal];
        weiboBtn.titleLabel.font = btnFont;
        [weiboBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [weiboBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [weiboBtn addTarget:self action:@selector(slideSegmentBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        weiboBtn.selected = YES;
        [_slidePageSegmentView addSubview:weiboBtn];
        
        CGFloat indexLineH = 3.0;
        CGFloat indexLineY = MYZMineViewControllerSlidePageSegmentViewH - indexLineH;
        UIView * indexLine = [[UIView alloc] initWithFrame:CGRectMake(btn2X, indexLineY, btn2W, indexLineH)];
        indexLine.backgroundColor = [UIColor orangeColor];
        [_slidePageSegmentView addSubview:indexLine];
        self.slidePageSegmentLine = indexLine;
        
        self.slidePageSegmentBtnArray = @[zhuyeBtn, weiboBtn];
        
    }
    return _slidePageSegmentView;
}


- (UIView *)slidePageNavBarView {
    if (_slidePageNavBarView == nil) {
        _slidePageNavBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 64)];
        _slidePageNavBarView.backgroundColor = [UIColor whiteColor];
        _slidePageNavBarView.alpha = 1.0;
    }
    return _slidePageNavBarView;
}


- (NSMutableArray *)tableViews {
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
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
        
        RLMRealm * realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addOrUpdateObject:self.userInfo];
        [realm commitWriteTransaction];
        
        [self resetHeaderViewData];
        [self.infoDataArray removeAllObjects];
        [self.infoDataArray addObjectsFromArray:[self resetMineInfoDataWithUserInfo:self.userInfo]];
        [self.mineInfoTableView reloadData];
        
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
    }];
}


- (void)resetHeaderViewData
{
    
    //[self.slidePageHeadBackgroundView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.cover_image_phone]];
    //    [self.headerBgImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.cover_image_phone]];
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
        
        //刷新用户微博视图
        [self.mineStatusTableView reloadData];
        
    } failure:^(NSError *error) {
        MYZLog(@" --- error %@ ", error);
        [SVProgressHUD dismiss];
    }];
}


- (NSMutableArray *)infoDataArray {
    if (_infoDataArray == nil) {
        _infoDataArray = [NSMutableArray array];
    }
    return _infoDataArray;
}

- (NSArray *)resetMineInfoDataWithUserInfo:(MYZUserInfo *)userInfo {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    NSDate * createDate = [dateFormatter dateFromString:userInfo.created_at];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString * dateStr = [dateFormatter stringFromDate:createDate];
    
    return @[@{@"title":@"昵称", @"subTitle":_userInfo.name}, @{@"title":@"性别", @"subTitle":_userInfo.gender},
             @{@"title":@"简介", @"subTitle":_userInfo.desc},  @{@"title":@"注册时间", @"subTitle":dateStr} ];
}




- (void)dealloc {
    
    //NSLog(@"dealloc");
    
    for (UITableView * tableView in self.tableViews) {
        [tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

@end
