//
//  ZHWebViewController.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHWebViewController : UIViewController

//协议界面
@property(nonatomic,copy)NSString *urlString; //协议url
@property(nonatomic,copy)NSString *navTitle; //协议标题

@end

NS_ASSUME_NONNULL_END
