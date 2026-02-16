//
//  ZHNewsBannerCell.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <UIKit/UIKit.h>
#import "ZhLatestNewsTopStories.h"
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsBannerCell : UICollectionViewCell<SDCycleScrollViewDelegate>

@property(nonatomic,strong)NSArray<ZHLatestNewsTopStories *> *bannerData;
@property(nonatomic,strong)UILabel *hintLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,copy)void(^clickItemBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
