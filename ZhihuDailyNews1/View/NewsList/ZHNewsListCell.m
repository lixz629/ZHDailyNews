//
//  ZHNewsListCell.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ZHNewsListCell.h"
#import "Masonry.h" //布局
#import "SDWebImage.h" //下载图片

@implementation ZHNewsListCell

//重写init方法
- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.titleLabel = [[UILabel alloc]init];
        self.hintLabel = [[UILabel alloc]init];
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.hintLabel];
        [self.contentView addSubview:self.imgView];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    //新闻图片
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-15);
        make.width.height.mas_equalTo(70);
    }];
    
    //新闻标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_top);
        make.left.offset(15);
        make.right.equalTo(self.imgView.mas_left).offset(-15);
    }];
    
    //作者信息及阅读所需时间
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
}

//重写model的setter方法
- (void)setStories:(ZHNewsStories *)stories{
    //将传入的stories复制给成员变量_stories
    _stories = stories;
    //赋值方法
    [self settingData];
    //根据是否阅读控制新闻字体颜色显示
    if(stories.isRead){
        self.titleLabel.textColor = [UIColor secondaryLabelColor];
    }else{
        self.titleLabel.textColor = [UIColor labelColor];
    }
}

//赋值方法
-(void)settingData{
    self.titleLabel.text = self.stories.title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:23];
    self.titleLabel.numberOfLines = 2;
    self.hintLabel.text = self.stories.hint;
    self.hintLabel.font = [UIFont systemFontOfSize:15];
    self.hintLabel.textColor = [UIColor secondaryLabelColor];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.stories.images[0]]];
}

@end
