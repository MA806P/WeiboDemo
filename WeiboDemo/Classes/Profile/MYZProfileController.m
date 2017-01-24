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

static NSString * const CellId = @"CellId";
static CGFloat alpha = 0;
static CGFloat const headerH = 250.0;
static CGFloat const AngleScale = 2.0 * M_PI / 180.0;

static NSString * const IndicatorAnimationKey = @"IndicatorAnimationKey";

@interface MYZProfileController ()

@property (nonatomic, assign) BOOL isChangeStatusBar;

@property (nonatomic, weak) UIView * header;
@property (nonatomic, weak) UIImageView * indicatorImgView;
@property (nonatomic, strong) CABasicAnimation * rotateAnimation;

@end

@implementation MYZProfileController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self scrollViewDidScroll:self.tableView];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置当有导航栏自动添加64的高度的属性为NO
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 46, 0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellId];
    
    
    //设置tableView的头部视图
    UIView * tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, headerH)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, headerH)];
    imageView.image = [UIImage imageNamed:@"11"];
    [self.tableView addSubview:imageView];
    self.header = imageView;
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
    
    
    //判断是否授权
    MYZAccount * account = [MYZTools account];
    if (account == nil)
    {
        [MYZTools showAlertWithText:@"用户未登录"];
        MYZOAuthController * oauthVC = [[MYZOAuthController alloc] init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:oauthVC];
        return;
    }
    
//    //获取用户信息
//    NSDictionary * showParameter = @{@"access_token":account.access_token,@"uid":account.uid};
//    [MYZHttpTools get:@"https://api.weibo.com/2/users/show.json" parameters:showParameter progress:^(NSProgress *progress) {
//    } success:^(id response) {
//        NSDictionary * userInfoDic = (NSDictionary *)response;
//        MYZLog(@" --- %@ ", userInfoDic);
//    } failure:^(NSError *error) {
//        MYZLog(@" --- error %@ ", error);
//    }];
//    
//    //用户最新发表的微博列表
//    /*
//     screen_name	false	string	需要查询的用户昵称。
//     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
//     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
//     count	false	int	单页返回的记录条数，最大不超过100，超过100以100处理，默认为20。
//     page	false	int	返回结果的页码，默认为1。
//     base_app	false	int	是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
//     feature	false	int	过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
//     trim_user	false	int	返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
//     */
//    NSDictionary * userTimelineParameter = @{@"access_token":account.access_token,@"uid":account.uid};
//    [MYZHttpTools get:@"https://api.weibo.com/2/statuses/user_timeline.json" parameters:userTimelineParameter progress:^(NSProgress *progress) {
//    } success:^(id response) {
//        NSDictionary * userTimelineDic = (NSDictionary *)response;
//        MYZLog(@" --- %@ ", userTimelineDic);
//    } failure:^(NSError *error) {
//        MYZLog(@" --- error %@ ", error);
//    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@" %d -- %d ", (int)indexPath.section, (int)indexPath.row];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"section-%d", (int)section];
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
        self.header.frame = CGRectMake(headerX, offsetY, headerW, headerH-offsetY);
        
        if (StartedLoading == NO)
        {
            self.indicatorImgView.hidden = NO;
            self.indicatorImgView.transform = CGAffineTransformRotate(self.indicatorImgView.transform, (offsetY-CurrentOffsetY)*AngleScale);
        }
        CurrentOffsetY = offsetY;
        
    }
    else if (offsetY >= 0)
    {
        self.header.frame = CGRectMake(0, 0, screenW, headerH);
        if (StartedLoading == NO) { self.indicatorImgView.hidden = YES; }
    }
    //NSLog(@"---- %.2lf  %@  %@", offsetY, NSStringFromCGRect(self.header.frame), NSStringFromCGRect(self.tableView.tableHeaderView.frame));
    
    {
        alpha =  offsetY/headerH;
        alpha = (alpha <= 0)?0:alpha;
        alpha = (alpha >= 1)?1:alpha;
        
        
        //NSLog(@" --- %.2f", alpha);
        
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
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = scrollView.contentOffset.y;
    //NSLog(@"-- r = %.2lf", -offsetY);
    if (-offsetY > 60 && StartedLoading == NO)
    {
        StartedLoading = YES;
        [self.indicatorImgView.layer addAnimation:self.rotateAnimation forKey:IndicatorAnimationKey];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self headIndicatorEndRefreshing];
            
        });
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


@end
