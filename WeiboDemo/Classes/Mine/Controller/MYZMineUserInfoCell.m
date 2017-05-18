//
//  MYZMineUserInfoCell.m
//  WeiboDemo
//
//  Created by MA806P on 2017/5/18.
//  Copyright © 2017年 MA806P. All rights reserved.
//

#import "MYZMineUserInfoCell.h"

@interface MYZMineUserInfoCell ()

@property (nonatomic, weak) UILabel * title;
@property (nonatomic, weak) UILabel * subTitle;

@end

@implementation MYZMineUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:title];
        self.title = title;
        
        UILabel * subTitle = [[UILabel alloc] init];
        subTitle.font = [UIFont systemFontOfSize:15];
        subTitle.textColor = [UIColor grayColor];
        [self.contentView addSubview:subTitle];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.title.frame = CGRectMake(10, 0, 80, self.bounds.size.height);
    self.subTitle.frame = CGRectMake(110, 0, self.bounds.size.width-110, self.bounds.size.height);
    
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    self.title.text = dict[@"title"];
    self.subTitle.text = dict[@"subTitle"];
}


@end
