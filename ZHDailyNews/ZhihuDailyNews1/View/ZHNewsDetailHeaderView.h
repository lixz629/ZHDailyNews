//
//  ZHNewsDetailHeaderView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsDetailHeaderView : UIView

@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *authorLabel;
@property(nonatomic,strong)UIVisualEffectView *visualEffectView;
@property(nonatomic,strong)CAGradientLayer *maskLayer;
@property(nonatomic,strong)UIButton *linkButton;

-(void)settingData:(NSDictionary *)responseObject;
-(void)settingAuthorName:(NSString *)authorName;
-(void)refreshLayoutFroce;

@end

NS_ASSUME_NONNULL_END
