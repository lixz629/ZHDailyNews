//
//  ZHLatestNewsModel.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ZHNewsModel.h"
#import "ZHNewsStories.h"
#import "ZHNewsTopStories.h"

@implementation ZHNewsModel

//第三方库yymodel的类方法 作用是在yymodel将网络请求拿到的json数据转换为相应的model数据时指明某一类数据应该转化为哪一类model
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{
        //json数据里的stories这个字典数组里的每一个大字典都指明应转换为ZHNewsStories类型
        @"stories" : [ZHNewsStories class],
        //top_stories同理
        @"top_stories" : [ZHNewsTopStories class]
    };
}

@end
