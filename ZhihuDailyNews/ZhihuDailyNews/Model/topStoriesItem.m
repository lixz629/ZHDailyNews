//
//  topStoriesItem.m
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/6.
//

#import "topStoriesItem.h"

@implementation topStoriesItem

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self == [super init]){
        self.url = dict[@"url"];
        self.title = dict[@"title"];
        self.image = dict[@"image"];
        self.hint = dict[@"hint"];
    }
    return self;
}

+ (id)itemWithDict:(NSDictionary *)dict{
    return [[topStoriesItem alloc]initWithDict:dict];
}

@end
