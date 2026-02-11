//
//  ZHLatestNewsModel.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ZHLatestNewsModel.h"
#import "ZHLatestNewsStories.h"
#import "ZHLatestNewsTopStories.h"

@implementation ZHLatestNewsModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        @"stories" : [ZHLatestNewsStories class],
        @"top_stories" : [ZHLatestNewsTopStories class]
    };
}

@end
