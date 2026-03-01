//
//  ZHLoginMainView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHLoginMainView : UIView

//登录界面的中心部分
@property(nonatomic,strong)UILabel *loginLabel; //“登录知乎日报”
@property(nonatomic,strong)UILabel *loginStyleLabel; //“选择登录方式”
@property(nonatomic,strong)UIButton *ZHbutton; //知乎按钮
@property(nonatomic,strong)UIButton *WBbutton; //微博按钮
@property(nonatomic,strong)UIButton *stateButton; //同意相关协议的按钮
@property(nonatomic,copy)void(^clickZHBlock)(void); //点击知乎按钮后会执行的代码块
@property(nonatomic,copy)void(^clickWBBlock)(void); //点击微博按钮后会执行的代码块
@property(nonatomic,copy)void(^changeStateBlock)(void); //点击同意相关协议按钮后会执行的代码块

@end

NS_ASSUME_NONNULL_END
