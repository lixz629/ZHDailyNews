//
//  ZHNewsDetailHeaderView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsDetailHeaderView : UIView
//新闻详情页顶部的相关内容的展示 包含图片，新闻标题，作者，点击跳转到知乎查看原文的按钮
@property(nonatomic,strong)UIImageView *imgView; //图片
@property(nonatomic,strong)UILabel *titleLabel; //新闻标题
@property(nonatomic,strong)UILabel *authorLabel; //作者信息
@property(nonatomic,strong)UIVisualEffectView *visualEffectView; //遮罩层view
@property(nonatomic,strong)CAGradientLayer *maskLayer; //渐变图层
@property(nonatomic,strong)UIButton *linkButton; //跳转按钮

-(void)settingData:(NSDictionary *)responseObject; //根据网络请求回的内容填充相关数据
-(void)settingAuthorName:(NSString *)authorName; //设置作者信息
-(void)refreshLayoutFroce; //刷新UI

@end

NS_ASSUME_NONNULL_END
