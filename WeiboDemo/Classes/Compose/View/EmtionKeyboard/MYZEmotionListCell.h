//
//  MYZEmotionListCell.h
//  WeiboDemo
//
//  Created by 159CaiMini02 on 16/11/11.
//  Copyright © 2016年 MA806P. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN CGFloat const EmotionListSectionFooterH;

@interface MYZEmotionListCell : UICollectionViewCell

@property (nonatomic, weak) UILabel * emotionEmptyLabel;
@property (nonatomic, weak) UILabel * emotionRecentLabel;

/** 要显示的表情模型数组 */
@property (nonatomic, copy) NSArray * emotionArray;

@end
