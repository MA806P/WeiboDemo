//
//  MYZStatusViewController.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/12/16.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZStatusViewController.h"
#import "MYZStatusTool.h"
#import "MYZStatusFrame.h"
#import "MYZStatusOriginal.h"
#import "MYZStatusCell.h"
#import "MYZStatusComment.h"
#import "MYZUserInfo.h"
#import "MYZStatusTextItem.h"
#import "MYZWebViewController.h"
#import "MYZComposeController.h"

static NSString * const StatusDetailCellID = @"StatusDetailCellID";
static NSString * const StatusCommentCellID = @"StatusCommentCellID";

@interface MYZStatusViewController () <MYZStatusCellDelegate>

@property (nonatomic, strong) NSMutableArray * commentArray;

@end

@implementation MYZStatusViewController

- (NSMutableArray *)commentArray
{
    if (_commentArray == nil)
    {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //tableView 设置
    self.tableView.backgroundColor = MYZColor(242, 242, 242);
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[MYZStatusCell class] forCellReuseIdentifier:StatusDetailCellID];
    
    
    /**
    *  access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
    *  id	true	int64	需要跳转的微博ID。
    */
    //这个接口只能查看授过权的用户微博其他人的微博看不到，"error":"Permission Denied!"
    
//    MYZStatusOriginal * status = self.statusFrame.status;
//    
//    NSDictionary * paramDict = @{@"access_token":[[MYZTools account] access_token], @"id":@(self.statusId.integerValue)};
//    [MYZStatusTool getStatusDetailWithParam:paramDict success:^(id result) {
//        NSLog(@" -- %@ ", result);
//    } failure:^(NSError *error) {
//        NSLog(@" -- %@ ", error);
//    }];

    
    NSDictionary * paramDic = @{@"access_token":[[MYZTools account] access_token], @"id":self.statusFrame.status.mid};
    [MYZHttpTools get:@"https://api.weibo.com/2/comments/show.json" parameters:paramDic progress:^(NSProgress *progress) {
        ;
    } success:^(id response) {
        
        NSArray * commentArray = [response objectForKey:@"comments"];
        if ([commentArray isKindOfClass:[NSArray class]] && commentArray.count > 0)
        {
            [self.commentArray removeAllObjects];
            for (NSDictionary * dic in commentArray)
            {
                MYZStatusComment * comment = [MYZStatusComment statusCommentWithDict:dic];
                [self.commentArray addObject:comment];
            }
            [self.tableView reloadData];
            if (self.type == StatusViewControllerTypeComment)
            {                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }

        }
    } failure:^(NSError *error) {
        MYZLog(@" --- %@ ", error);
    }];
    
}


#pragma mark - UITableView data sources , delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        MYZStatusCell * cell = [tableView dequeueReusableCellWithIdentifier:StatusDetailCellID forIndexPath:indexPath];
        cell.statusFrame = self.statusFrame;
        cell.delegate = self;
        return cell;
    }
    else
    {
        MYZStatusComment * comment = self.commentArray[indexPath.row];
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:StatusCommentCellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:StatusCommentCellID];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
            cell.detailTextLabel.numberOfLines = 0;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",comment.user.name, comment.created_at, comment.source];
        cell.detailTextLabel.text = comment.text;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return self.statusFrame.cellHeight;
    }
    else if (indexPath.section == 1)
    {
        MYZStatusComment * comment = self.commentArray[indexPath.row];
        CGFloat cellH = [comment.text myz_stringSizeWithMaxSize:CGSizeMake(SCREEN_W - 20, 300) andFont:[UIFont systemFontOfSize:11]].height + 22;
        return cellH > 44 ? cellH : 44;
    }
    return 44;
}


#pragma mark - 点击事件, 正文连接 评论 转发 点赞

//点击微博正文能点的地方
- (void)statusTouchTextLinkWithTextItem:(MYZStatusTextItem *)linkTextItem statusFrame:(MYZStatusFrame *)statusFrame
{
    if (linkTextItem.type == StatusTextItemTypeUrl)
    {
        NSString * linkString = linkTextItem.text;
        if ([linkString hasPrefix:@"http"])
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
    MYZStatusOriginal * status = statusFrame.status;
    if (status)
    {
        MYZComposeController * compose = [[MYZComposeController alloc] init];
        compose.composeType = ComposeTypeComment;
        compose.status = status;
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:compose];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

//点赞
- (void)statusTouchLikeWithStatus:(MYZStatusFrame *)statusFrame
{
    
}



@end
