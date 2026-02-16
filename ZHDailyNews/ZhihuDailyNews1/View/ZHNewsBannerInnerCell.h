//
//  ZHNewsBannerInnerCell.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsBannerInnerCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *hintLabel;
@property(nonatomic,strong)UIVisualEffectView *visualEffectView;

-(void)refreshLayoutForce;

@end

NS_ASSUME_NONNULL_END
