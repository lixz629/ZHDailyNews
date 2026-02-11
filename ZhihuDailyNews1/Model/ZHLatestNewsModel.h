//
//  ZHLatestNewsModel.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "ZHLatestNewsStories.h"
#import "ZHLatestNewsTopStories.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZHLatestNewsModel : NSObject<YYModel>

@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSArray<ZHLatestNewsStories *> *stories;
@property(nonatomic,strong)NSArray<ZHLatestNewsTopStories *> *top_stories;



@end

NS_ASSUME_NONNULL_END
