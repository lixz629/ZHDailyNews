//
//  ZHNewsBannerInnerCell.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsBannerInnerCell : UICollectionViewCell

//还原轮播图设计风格的自定义cell
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *hintLabel;
//轮播图上标题所在区域的文字遮罩层
@property(nonatomic,strong)UIVisualEffectView *visualEffectView;

//刷新文字遮罩层的方法
-(void)refreshLayoutForce;

@end

NS_ASSUME_NONNULL_END
