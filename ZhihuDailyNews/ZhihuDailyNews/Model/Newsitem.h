//
//  Newsitem.h
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Newsitem : NSObject

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *hint;
@property(nonatomic,strong)NSArray *images;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(id)itemWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
