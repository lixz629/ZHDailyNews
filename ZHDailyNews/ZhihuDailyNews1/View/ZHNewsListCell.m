//
//  ZHNewsListCell.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ZHNewsListCell.h"
#import "Masonry.h"
#import "SDWebImage.h"

@implementation ZHNewsListCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        self.hintLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.hintLabel];
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-15);
        make.width.height.mas_equalTo(70);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top);
        make.left.offset(15);
        make.right.equalTo(self.imgView.mas_left).offset(-15);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
}

- (void)setStories:(ZHLatestNewsStories *)stories{
    _stories = stories;
    [self settingData];
}

-(void)settingData{
    self.titleLabel.text = self.stories.title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    self.titleLabel.numberOfLines = 2;
    self.hintLabel.text = self.stories.hint;
    self.hintLabel.font = [UIFont systemFontOfSize:15];
    self.hintLabel.textColor = [UIColor grayColor];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.stories.images[0]]];
}

@end
