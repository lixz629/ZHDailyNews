//
//  ZHNewsDetailHeaderView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/13.
//

#import "ZHNewsDetailHeaderView.h"
#import "SDWebImage.h"
#import "Masonry.h"

@implementation ZHNewsDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.imgView = [[UIImageView alloc]init];
        [self addSubview:self.imgView];
        self.titleLabel = [[UILabel alloc]init];
        self.authorLabel = [[UILabel alloc]init];
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark];
        self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        self.maskLayer = [CAGradientLayer layer];
        self.maskLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
        self.maskLayer.locations = @[@0.0,@0.2];
        self.visualEffectView.layer.mask = self.maskLayer;
        self.visualEffectView.alpha = 0.6;
        [self addSubview:self.visualEffectView];
        [self.visualEffectView.contentView addSubview:self.titleLabel];
        [self addSubview:self.authorLabel];
        self.linkButton = [[UIButton alloc]init];
        [self addSubview:self.linkButton];
        [self makeConstraints];
    }
    return self;
}

-(void)settingData:(NSDictionary *)responseObject{
    [self.imgView sd_setImageWithURL:responseObject[@"image"]];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    self.titleLabel.text = responseObject[@"title"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:27];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.linkButton setTitle:@"进入「知乎」查看原文" forState:UIControlStateNormal];
    [self.linkButton setTitleColor:[UIColor colorWithRed:0.00 green:0.52 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    self.linkButton.titleLabel.font = [UIFont systemFontOfSize:20];
}

- (void)settingAuthorName:(NSString *)authorName{
    self.authorLabel.text = authorName;
    self.authorLabel.font = [UIFont systemFontOfSize:20];
    self.authorLabel.textColor = [UIColor grayColor];
    self.authorLabel.numberOfLines = 0;
}

-(void)makeConstraints{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self.imgView.mas_bottom).offset(-10);
    }];
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.imgView);
        make.top.equalTo(self.titleLabel.mas_top).offset(-15);
    }];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(25);
        make.left.equalTo(self).offset(20);
    }];
    [self.linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.authorLabel);
        make.left.equalTo(self.authorLabel.mas_right).offset(10);
    }];
}

- (void)refreshLayoutFroce{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.visualEffectView.layer.mask.frame = self.visualEffectView.bounds;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.maskLayer.frame = self.visualEffectView.bounds;
}


@end
