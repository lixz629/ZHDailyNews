//
//  ItemCell.m
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/4.
//

#import "ItemCell.h"
#define WIDTH self.contentView.frame.size.width
#define HEIGHT self.contentView.frame.size.height

@implementation ItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.title = [[UILabel alloc]init];
        [self.contentView addSubview:self.title];
        self.hint = [[UILabel alloc]init];
        [self.contentView addSubview:self.hint];
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

- (void)setItem:(Newsitem *)item{
    _item = item;
    
    [self settingFrame];
    
    [self settingData];
}

-(void)settingFrame{
    CGFloat padding = 30.0;
    self.title.frame = CGRectMake(padding, padding * 0.6, WIDTH - padding * 4.8, HEIGHT - padding );
    self.hint.frame = CGRectMake(padding, HEIGHT - padding * 2.0, WIDTH, padding * 4);
    self.imgView.frame = CGRectMake(WIDTH - padding * 3.6 , padding, 90, 90);
}

-(void)settingData{
    self.title.text = self.item.title;
    self.title.font = [UIFont boldSystemFontOfSize:23];
    self.title.numberOfLines = 0;
    self.hint.text = self.item.hint;
    self.hint.font = [UIFont systemFontOfSize:15];
    self.hint.textColor = [UIColor grayColor];
    self.hint.numberOfLines = 0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *imageUrl = [NSURL URLWithString:self.item.images[0]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = [UIImage imageWithData:imageData];
        });
    });
}

@end
