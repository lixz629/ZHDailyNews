//
//  ZHDateHeaderView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHDateHeaderView : UIView

//顶部日期，问候语及登录按钮
@property(nonatomic,strong)UILabel *dayLabel; //日期
@property(nonatomic,strong)UILabel *monthLabel; //月份
@property(nonatomic,strong)UILabel *greetLabel; //问候语
@property(nonatomic,strong)UIView *lineView; //日期与问候语间的分隔线
@property(nonatomic,strong)UIButton *loginButton; //登录按钮
@property(nonatomic,copy)void(^loginBlock)(void); //传递登录信息

-(void)settingDate:(NSString *)dateString; //根据网络请求返回的日期数据设置对应日期的显示

@end

NS_ASSUME_NONNULL_END
