//
//  MYZEmotionListView.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/31.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionListView.h"
#import "MYZEmotionListCell.h"

static NSString * const EmotionListCellID = @"EmotionListCellID";
static NSString * const EmotionListSectionFooter = @"EmotionListSectionFooter";

CGFloat EmotionListSectionFooterH = 20;

@interface MYZEmotionListView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView * collectionView;
@property (nonatomic, weak) UIPageControl * pageControlFooter;

@end

@implementation MYZEmotionListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat collectionViewH = ComposeEmotionKeyboardH - ComposeEmotionToolBarH - EmotionListSectionFooterH;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_W, collectionViewH);
        
        
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, collectionViewH) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[MYZEmotionListCell class] forCellWithReuseIdentifier:EmotionListCellID];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        UIPageControl * pageControlFooter = [[UIPageControl alloc] init];
        pageControlFooter.numberOfPages = 3;
        [self addSubview:pageControlFooter];
        self.pageControlFooter = pageControlFooter;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.pageControlFooter.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), SCREEN_W, EmotionListSectionFooterH);
}


#pragma mark - UICollectionView Data Source, Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYZEmotionListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmotionListCellID forIndexPath:indexPath];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath * scrollIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    self.pageControlFooter.currentPage = scrollIndexPath.item;
}




@end
