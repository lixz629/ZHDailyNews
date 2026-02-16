//
//  ZHNewsListCell.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <UIKit/UIKit.h>
#import "ZHLatestNewsStories.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsListCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *hintLabel;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)ZHLatestNewsStories *stories;

@end

NS_ASSUME_NONNULL_END
