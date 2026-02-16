//
//  ZHDateHeaderView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHDateHeaderView : UIView

@property(nonatomic,strong)UILabel *dayLabel;
@property(nonatomic,strong)UILabel *monthLabel;
@property(nonatomic,strong)UILabel *greetLabel;
@property(nonatomic,strong)UIView *lineView;

-(void)settingDate:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
