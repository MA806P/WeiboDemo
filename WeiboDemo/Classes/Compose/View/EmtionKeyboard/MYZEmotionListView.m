//
//  MYZEmotionListView.m
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/10/31.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import "MYZEmotionListView.h"
#import "MYZEmotionListCell.h"
#import "MYZEmotion.h"

static NSString * const EmotionListCellID = @"EmotionListCellID";
static NSString * const EmotionListSectionFooter = @"EmotionListSectionFooter";

CGFloat const EmotionListSectionFooterH = 30;


@interface MYZEmotionListView () <UICollectionViewDelegate, UICollectionViewDataSource, MYZEmotionListCellDelegate>

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
        CGFloat collectionViewH = ComposeEmotionKeyboardH - ComposeEmotionToolBarH;// - EmotionListSectionFooterH;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(SCREEN_W, collectionViewH);
        
        
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, collectionViewH) collectionViewLayout:layout];
        collectionView.backgroundColor = MYZColor(248, 248, 248);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[MYZEmotionListCell class] forCellWithReuseIdentifier:EmotionListCellID];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        UIPageControl * pageControlFooter = [[UIPageControl alloc] init];
        pageControlFooter.pageIndicatorTintColor = [UIColor grayColor];
        pageControlFooter.currentPageIndicatorTintColor = [UIColor orangeColor];
        pageControlFooter.hidden = YES;
        //替换pageControl的小点的图片
        //[pageControlFooter setValue:[UIImage imageNamed:@""] forKeyPath:@"_currentPageImage"];
        //[pageControlFooter setValue:[UIImage imageNamed:@""] forKeyPath:@"_pageImage"];
        [self addSubview:pageControlFooter];
        self.pageControlFooter = pageControlFooter;
        
        self.scrollSection = -1;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pageControlFooter.frame = CGRectMake(0, self.frame.size.height - EmotionListSectionFooterH, SCREEN_W, EmotionListSectionFooterH);
}

#pragma mark - setter getter



- (void)setEmotionDataArray:(NSArray *)emotionDataArray
{
    _emotionDataArray = emotionDataArray;
    
    [self.collectionView reloadData];
}

- (void)addRecentEmotion:(MYZEmotion *)emotion
{
    NSMutableArray * recentEmotionArray = [[self.emotionDataArray objectAtIndex:0] firstObject];
    [recentEmotionArray removeObject:emotion];
    [recentEmotionArray insertObject:emotion atIndex:0];
    if (recentEmotionArray.count > 20)
    {
        //最近使用的表情 最多只显示二十个
        [recentEmotionArray removeLastObject];
    }
    [NSKeyedArchiver archiveRootObject:recentEmotionArray toFile:MYZEmotionRecentDataPath];
    
    //刷新最近使用表情的那个section
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


#pragma mark - UICollectionView Data Source, Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //常用，默认，emoji，小浪花表情
    return self.emotionDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //每页最多只显示20个表情，常用表情要注意 只有一页 在添加的时候已经判断了 数组超过20就会移除 没有数据也显示空白
    //修改获取到的数组已经分好组了20一组
    return [[self.emotionDataArray objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYZEmotionListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:EmotionListCellID forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        if ([[[self.emotionDataArray objectAtIndex:0] firstObject] count] > 0)
        {
            cell.emotionEmptyLabel.hidden = YES;
            cell.emotionRecentLabel.hidden = NO;
        }
        else
        {
            cell.emotionEmptyLabel.hidden = NO;
            cell.emotionRecentLabel.hidden = YES;
        }
    }
    else
    {
        cell.emotionEmptyLabel.hidden = YES;
        cell.emotionRecentLabel.hidden = YES;
    }
    cell.emotionArray = [self.emotionDataArray[indexPath.section] objectAtIndex:indexPath.item];
    cell.delegate = self;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSIndexPath * scrollIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
//    self.pageControlFooter.currentPage = scrollIndexPath.item;
    
    CGPoint point = scrollView.contentOffset;
    point.x += SCREEN_W*0.5;
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    //MYZLog(@"--- %@  %ld-%ld ", NSStringFromCGPoint(point),indexPath.section, indexPath.item);
    
    if (indexPath.section == 0)
    {
        self.pageControlFooter.hidden = YES;
    }
    else
    {
        self.pageControlFooter.hidden = NO;
        self.pageControlFooter.numberOfPages = [[self.emotionDataArray objectAtIndex:indexPath.section] count];
        self.pageControlFooter.currentPage = indexPath.item;
    }
    
    if (self.scrollSection != indexPath.section && self.clickChangeType == NO && [self.delegate respondsToSelector:@selector(emotionListScrollToType:)])
    {
        [self.delegate emotionListScrollToType:indexPath.section+MYZEmotionToolBarButtonTypeRecent];
        
    }
    self.scrollSection = indexPath.section;
    self.clickChangeType = NO;
}

#pragma mark - MYZEmotionListCell Delegate

- (void)emotionListCellTouchWithEmotion:(MYZEmotion *)emotion
{
    NSIndexPath * touchIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    //点击最近使用的表情时不去添加
    if (touchIndexPath.section > 0)
    {
        [self addRecentEmotion:emotion];
    }
    
    //给控制器发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ComposeEmotionSelectedKey object:emotion];
}




#pragma mark - 外部调用

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
