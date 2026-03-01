//
//  ZHShareCell.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHShareCell : UICollectionViewCell

//点击分享按钮后弹出的白色弹窗内的单个cell
@property(nonatomic,strong)UIImageView *imgView; //应用图标
@property(nonatomic,strong)UILabel *iconLabel; //应用名称

-(void)updateWithData:(NSDictionary *)data; //赋值方法

@end

NS_ASSUME_NONNULL_END
