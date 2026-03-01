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
        self.imgView = [[UIImageView alloc]init];
        self.iconLabel = [[UILabel alloc]init];
        self.iconLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.iconLabel];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    //图标
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    
    //图标名称
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(8);
        make.left.right.equalTo(self.contentView);
        make.centerX.equalTo(self.imgView);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}

//更新数据（赋值）
- (void)updateWithData:(NSDictionary *)data{
    self.imgView.image = [UIImage imageNamed:data[@"image"]];
    self.iconLabel.text = data[@"text"];
}

@end
