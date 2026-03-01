//
//  ZHLatestNewsModel.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <Foundation/Foundation.h>
#import "YYModel.h" //将网络请求得到的json数据直接转化为model
#import "ZHNewsStories.h" //新闻model
#import "ZHNewsTopStories.h" //顶部轮播图的model

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsModel : NSObject<YYModel>

//处理当日新闻数据 根据网络接口返回的数据分别存储到下面三个部分里
@property(nonatomic,strong)NSString *date;
//当日新闻相关的数据
@property(nonatomic,strong)NSArray<ZHNewsStories *> *stories;
//顶部轮播图相关的数据
@property(nonatomic,strong)NSArray<ZHNewsTopStories *> *top_stories;



@end

NS_ASSUME_NONNULL_END
