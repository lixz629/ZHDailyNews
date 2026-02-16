//
//  ZHNewsBannerInnerCell.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/10.
//

#import "ZHNewsBannerInnerCell.h"
#import "Masonry.h"

@implementation ZHNewsBannerInnerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
        self.titleLabel = [[UILabel alloc]init];
        self.hintLabel = [[UILabel alloc]init];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark];
        self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
        maskLayer.locations = @[@0.0,@0.2];
        self.visualEffectView.layer.mask = maskLayer;
        self.visualEffectView.alpha = 0.6;
        [self.contentView addSubview:self.visualEffectView];
        [self.visualEffectView.contentView addSubview:self.titleLabel];
        [self.visualEffectView.contentView addSubview:self.hintLabel];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView).multipliedBy(0.4);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-25);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.hintLabel);
        make.bottom.equalTo(self.hintLabel.mas_top).offset(-8);
    }];
}

-(void)refreshLayoutForce{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.visualEffectView.layer.mask.frame = self.visualEffectView.bounds;
}

@end
