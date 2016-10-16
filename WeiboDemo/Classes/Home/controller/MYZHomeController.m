//
//  MYZHomeController.m
//  WeiboDemo
//
//  Created by MA806P on 16/9/27.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#define TempFilepath [MYZFileRootPath stringByAppendingPathComponent:@"property.txt"]
#define TempFilepath2 [MYZFileRootPath stringByAppendingPathComponent:@"propertyDic.txt"]

#import "MYZHomeController.h"
#import "MYZAccount.h"
#import "MYZUserInfo.h"
#import "MJRefresh.h"

#import "MYZStatus.h"

@interface MYZHomeController ()

@property (nonatomic, strong) MYZAccount * account;
@property (nonatomic, strong) MYZUserInfo * userInfo;

@end

@implementation MYZHomeController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.account = [MYZTools account];
    if (self.account == nil) { return; }
    
    
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf homeGetStatuses];
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
    
}



#pragma mark - 网络请求


- (void)homeGetStatuses
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
    
    NSDictionary * parameter = @{@"access_token":self.account.access_token, @"since_id":@(0), @"count":@(20)};
    [MYZHttpTools get:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:parameter progress:nil success:^(id response) {
        
        NSArray * statusDicts = [(NSDictionary *)response objectForKey:@"statuses"];
        //NSLog(@"%@", statusDicts);
        [statusDicts enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MYZStatus * status = [[MYZStatus alloc] initWithValue:obj];
            
            RLMRealm * realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm addObject:status];
            [realm commitWriteTransaction];
            
        }];
        
        
        
//        // 属性跟字典的key一一对应
//        NSMutableString *codes = [NSMutableString string];
//        // 遍历字典中所有key取出来
//        //NSLog(@"-- %@ ", [[statusesDict objectForKey:@"statuses"] firstObject]);
//        [[[statusesDict objectForKey:@"statuses"] firstObject] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            // key:属性名
//            NSString *code;
//            if ([obj isKindOfClass:[NSString class]]) {
//                code = [NSString stringWithFormat:@"/**   */\n@property NSString *%@;",key];
//            }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
//                code = [NSString stringWithFormat:@"/**   */\n@property BOOL %@;",key];
//            }else if ([obj isKindOfClass:[NSNumber class]]){
//                code = [NSString stringWithFormat:@"/**   */\n@property NSInteger %@;",key];
//            }else if ([obj isKindOfClass:[NSArray class]]){
//                code = [NSString stringWithFormat:@"/**   */\n@property NSArray *%@;",key];
//            }else if ([obj isKindOfClass:[NSDictionary class]]){
//                code = [NSString stringWithFormat:@"/**   */\n@property NSDictionary *%@;",key];
//            }
//            [codes appendFormat:@"\n%@\n",code];
//            
//        }];
//        NSLog(@"%@",codes);
        
        
        
        MYZLog(@"--- success ");
        
        
        
        
        
    } failure:^(NSError *error) {
        MYZLog(@"--- %@", error);
    }];
    
}









@end
