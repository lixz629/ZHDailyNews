//
//  ZHNewsBannerCell.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <UIKit/UIKit.h>
#import "ZHNewsTopStories.h"
#import "SDCycleScrollView.h" //实现无限循环的轮播图的第三方库

NS_ASSUME_NONNULL_BEGIN

//实现轮播图显示逻辑的cell
@interface ZHNewsBannerCell : UICollectionViewCell<SDCycleScrollViewDelegate>//遵循相关代理方法

@property(nonatomic,strong)NSArray<ZHNewsTopStories *> *bannerData; //存放轮播图数据的数组，数组中的每个对象都是ZHNewsTopStories类型
@property(nonatomic,strong)UILabel *hintLabel; //作者信息
@property(nonatomic,strong)UILabel *titleLabel; //新闻标题
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView; //轮播图view
@property(nonatomic,copy)void(^clickBannerItemBlock)(NSInteger index); //点击轮播图跳转到相应新闻的代码块

@end

NS_ASSUME_NONNULL_END
