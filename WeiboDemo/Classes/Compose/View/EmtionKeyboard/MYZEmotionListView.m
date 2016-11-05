//
//  MYZEmotionListView.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/31.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionListView.h"

@implementation MYZEmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        //collectionView.delegate = self;
        //collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:collectionView];
        
    }
    return self;
}

@end
