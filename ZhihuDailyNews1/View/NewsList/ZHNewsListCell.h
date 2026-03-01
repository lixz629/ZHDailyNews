//
//  ZHNewsListCell.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <UIKit/UIKit.h>
#import "ZHNewsStories.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsListCell : UICollectionViewCell

//轮播图下方的新闻列表对应的cell
@property(nonatomic,strong)UILabel *titleLabel; //新闻标题
@property(nonatomic,strong)UILabel *hintLabel; //标题下方的作者信息及所需阅读时间
@property(nonatomic,strong)UIImageView *imgView; //每条新闻右侧的图片
@property(nonatomic,strong)ZHNewsStories *stories; //model 用于设置相关数据

@end

NS_ASSUME_NONNULL_END
