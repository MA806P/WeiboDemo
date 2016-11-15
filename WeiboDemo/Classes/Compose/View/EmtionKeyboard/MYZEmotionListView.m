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
@property (nonatomic, assign) NSInteger scrollSection;
@property (nonatomic, assign) BOOL clickChangeType;

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
        collectionView.backgroundColor = [UIColor lightGrayColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[MYZEmotionListCell class] forCellWithReuseIdentifier:EmotionListCellID];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        UIPageControl * pageControlFooter = [[UIPageControl alloc] init];
        pageControlFooter.hidden = YES;
        [self addSubview:pageControlFooter];
        self.pageControlFooter = pageControlFooter;
        
        self.scrollSection = -1;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.pageControlFooter.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), SCREEN_W, EmotionListSectionFooterH);
}

#pragma mark - setter

- (void)setEmotionDataArray:(NSArray *)emotionDataArray
{
    //觉得还是在这判断是否有最近使用的表情好点
    
    
    
    _emotionDataArray = emotionDataArray;
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionView Data Source, Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //加上常用表情的分组，常用表情是变化的，选择一个表情就增加一个，但是只显示一页
    return self.emotionDataArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger items;
    if (section == 0)
    {
        items = 1;
    }
    else
    {
        items = [[self.emotionDataArray objectAtIndex:section-1] count]/20;
    }
    return items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYZEmotionListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmotionListCellID forIndexPath:indexPath];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSIndexPath * scrollIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
//    self.pageControlFooter.currentPage = scrollIndexPath.item;
    
    CGPoint point = scrollView.contentOffset;
    point.x += SCREEN_W*0.5;
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    MYZLog(@"--- %@  %ld-%ld ", NSStringFromCGPoint(point),indexPath.section, indexPath.item);
    
    if (indexPath.section == 0)
    {
        self.pageControlFooter.hidden = YES;
    }
    else
    {
        self.pageControlFooter.hidden = NO;
        self.pageControlFooter.numberOfPages = [[self.emotionDataArray objectAtIndex:indexPath.section-1] count]/20;
        self.pageControlFooter.currentPage = indexPath.item;
    }
    
    if (self.scrollSection != indexPath.section && self.clickChangeType == NO && [self.delegate respondsToSelector:@selector(emotionListScrollToType:)])
    {
        [self.delegate emotionListScrollToType:indexPath.section+MYZEmotionToolBarButtonTypeRecent];
        
    }
    self.scrollSection = indexPath.section;
    self.clickChangeType = NO;
}


#pragma mark - 外部滴啊用

- (void)emotionListViewShowWithType:(MYZEmotionToolBarButtonType)type
{
    self.clickChangeType = YES;
    
    switch (type) {
        case MYZEmotionToolBarButtonTypeRecent:
            //选择常用表情
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            break;
        case MYZEmotionToolBarButtonTypeDefault:
            //选择默认表情
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            break;
        case MYZEmotionToolBarButtonTypeEmoji:
            //选择emoji表情
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            break;
        case MYZEmotionToolBarButtonTypeLang:
            //选择小浪花
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            break;
        default:
            break;
    }
}


@end
