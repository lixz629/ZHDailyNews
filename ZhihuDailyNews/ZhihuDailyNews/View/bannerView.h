//
//  bannerView.h
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/6.
//

#import <UIKit/UIKit.h>
#import "topStoriesItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface bannerView : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)topStoriesItem *topItem;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *hintLabel;
@

@end

NS_ASSUME_NONNULL_END
