//
//  topStoriesItem.h
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface topStoriesItem : NSObject

@property(nonatomic,strong)NSString *hint;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *title;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(id)itemWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
