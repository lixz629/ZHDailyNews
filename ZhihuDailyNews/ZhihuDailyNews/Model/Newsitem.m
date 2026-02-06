//
//  Newsitem.m
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/4.
//

#import "Newsitem.h"

@implementation Newsitem

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self == [super init]){
        self.title = dict[@"title"];
        self.url = dict[@"url"];
        self.hint = dict[@"hint"];
        self.images = dict[@"images"];
    }
    return self;
}

+ (id)itemWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
