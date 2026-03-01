//
//  ZHLoginViewController.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/20.
//

#import <UIKit/UIKit.h>
#import "ZHLoginMainView.h" //中心控件

NS_ASSUME_NONNULL_BEGIN

//登录界面
@interface ZHLoginViewController : UIViewController<UITextViewDelegate>

@property(nonatomic,strong)UIButton *modeButton; //夜间模式
@property(nonatomic,strong)UIButton *settingButton; //设置
@property(nonatomic,strong)UITextView *agreementText; //相关协议
@property(nonatomic,strong)ZHLoginMainView *mainView; //中心控件

@end

NS_ASSUME_NONNULL_END
