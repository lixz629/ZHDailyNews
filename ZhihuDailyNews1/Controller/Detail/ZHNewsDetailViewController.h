//
//  ZHNewsDetailViewController.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsDetailViewController : UIViewController<UIScrollViewDelegate>

//新闻详情页vc
@property(nonatomic,strong)NSString *newsID; //新闻id
@property(nonatomic,strong)NSString *shareUrl; //分享url

@end

NS_ASSUME_NONNULL_END
