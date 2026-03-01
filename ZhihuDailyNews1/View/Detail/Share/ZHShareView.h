//
//  ZHShareView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHShareView : UIView

//分享界面

//类方法 负责将被点击图标的索引传给viewcontroller执行跳转逻辑
+(void)showWithcompletion:(void(^)(NSInteger index))completion;

@end

NS_ASSUME_NONNULL_END
