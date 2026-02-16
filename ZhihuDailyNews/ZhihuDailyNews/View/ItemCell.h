//
//  ItemCell.h
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/4.
//

#import <UIKit/UIKit.h>
#import "Newsitem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)UILabel *hint;
@property(nonatomic,strong)Newsitem *item;
@property(nonatomic,strong)UIImageView *imgView;

@end

NS_ASSUME_NONNULL_END
