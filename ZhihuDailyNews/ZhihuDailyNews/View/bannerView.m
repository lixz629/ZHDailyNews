//
//  bannerView.m
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/6.
//

#import "bannerView.h"

@implementation bannerView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 800)];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)setTopItem:(topStoriesItem *)topItem{
    self.topItem = topItem;
    [self settingImage];
}

-(void)settingImage{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *imageUrl = [NSURL URLWithString:self.topItem.image];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = [UIImage imageWithData:imageData];
        });
    });
    
}

@end
