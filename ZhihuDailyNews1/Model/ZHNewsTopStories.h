//
//  ZHLatestNewsTopStories.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNewsTopStories : NSObject

//顶部轮播图（top_stories）相关数据
@property(nonatomic,strong)NSString *hint; //作者信息
@property(nonatomic,strong)NSString *url; //新闻链接
@property(nonatomic,strong)NSString *image; //轮播图图片对应的url
@property(nonatomic,strong)NSString *title; //新闻标题
@property(nonatomic,strong)NSString *id; //新闻ID

@end

NS_ASSUME_NONNULL_END
