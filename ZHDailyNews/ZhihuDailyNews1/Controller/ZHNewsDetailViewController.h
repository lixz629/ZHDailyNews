//
//  ZHNewsDetailViewController.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsDetailViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong)NSString *newsID;
@property(nonatomic,strong)NSString *shareUrl;

@end

NS_ASSUME_NONNULL_END
