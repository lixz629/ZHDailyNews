//
//  ZHNewsListDateView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsListDateView : UICollectionReusableView

//往期新闻的日期标识
@property(nonatomic,strong)UILabel *dateLabel; //日期
@property(nonatomic,strong)UIView *lineView; //分隔线
@property(nonatomic,strong)NSString *date; //传入的日期数据

@end

NS_ASSUME_NONNULL_END
