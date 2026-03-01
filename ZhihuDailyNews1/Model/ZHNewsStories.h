//
//  ZHLatestNewsStories.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsStories : NSObject

//根据网络接口数据里的stories数组内的字典格式声明该类的相应属性

@property(nonatomic,strong)NSString *title; //新闻标题
@property(nonatomic,strong)NSString *url; //新闻对应的网页链接
@property(nonatomic,strong)NSString *hint; //标题下方的作者信息及所需阅读时间
@property(nonatomic,strong)NSArray<NSString *> *images; //每条新闻右侧的图片
@property(nonatomic,strong)NSString *id; //新闻ID（用于跳转到对应新闻）
@property(nonatomic,assign)bool isRead; //记录某条新闻是否阅读（控制新闻标题颜色）

@end

NS_ASSUME_NONNULL_END
