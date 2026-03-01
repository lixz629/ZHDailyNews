//
//  ZHShareCell.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/23.
//

#import "ZHShareCell.h"
#import "Masonry.h" //布局

@implementation ZHShareCell

//重写init方法
- (instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        self.shareButton = [[UIButton alloc]init];
        self.iconLabel = [[UILabel alloc]init];
        self.iconLabel.textAlignment = NSTextAlignmentCenter;
        self.shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.shareButton];
        [self.contentView addSubview:self.iconLabel];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    //图标
    [self.shareButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(50);
    }];
    
    //图标名称
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareButton.mas_bottom).offset(-10);
        make.left.right.equalTo(self.contentView);
        make.centerX.equalTo(self.shareButton.imageView);
    }];
}

//更新数据（赋值）
- (void)updateWithData:(NSDictionary *)data{
    [self.shareButton setImage:[UIImage imageNamed:data[@"image"]] forState:UIControlStateNormal] ;
    self.iconLabel.text = data[@"text"];
}

@end
