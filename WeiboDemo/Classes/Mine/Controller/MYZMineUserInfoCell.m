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
@property (nonatomic, weak) UIView * seperatorLine;

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
        self.subTitle = subTitle;
        
        UIView * seperatorLine = [[UIView alloc] init];
        seperatorLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
        [self.contentView addSubview:seperatorLine];
        self.seperatorLine = seperatorLine;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.title.frame = CGRectMake(10, 0, 80, self.bounds.size.height);
    self.subTitle.frame = CGRectMake(80, 0, self.bounds.size.width-80, self.bounds.size.height);
    self.seperatorLine.frame = CGRectMake(0, self.bounds.size.height-1.0, self.bounds.size.width, 1.0);
    
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    self.title.text = dict[@"title"];
    self.subTitle.text = dict[@"subTitle"];
}


@end
