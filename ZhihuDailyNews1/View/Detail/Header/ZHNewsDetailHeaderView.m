//
//  ZHNewsDetailHeaderView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/13.
//

#import "ZHNewsDetailHeaderView.h"
#import "SDWebImage.h" //下载图片
#import "Masonry.h" //布局

@implementation ZHNewsDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//重写init方法
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
    //下载图片并显示
    [self.imgView sd_setImageWithURL:responseObject[@"image"]];
    //将图片的显示方式设置为等比缩放填满整个容器
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    //裁剪掉超出边界的部分
    self.imgView.clipsToBounds = YES;
    
    self.titleLabel.text = responseObject[@"title"];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:27];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    [self.linkButton setTitle:@"进入「知乎」查看原文" forState:UIControlStateNormal];
    [self.linkButton setTitleColor:[UIColor colorWithRed:0.00 green:0.52 blue:1.00 alpha:1.00] forState:UIControlStateNormal];
    //设置抗压缩优先级为最高（优先确保跳转按钮显示完全）
    [self.linkButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.linkButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
}

- (void)settingAuthorName:(NSString *)authorName{
    self.authorLabel.text = authorName;
    self.authorLabel.font = [UIFont systemFontOfSize:18];
    self.authorLabel.textColor = [UIColor grayColor];
    self.authorLabel.numberOfLines = 1;
    //降低作者名称的抗压缩优先级
    [self.authorLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

-(void)makeConstraints{
    //顶部图片
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
    }];
    
    //新闻标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self.imgView.mas_bottom).offset(-10);
    }];
    
    //遮罩层
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.imgView);
        make.top.equalTo(self.titleLabel.mas_top).offset(-15);
    }];
    
    //作者信息
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(25);
        make.left.equalTo(self).offset(20);
    }];
    
    //跳转按钮
    [self.linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.authorLabel);
        make.left.equalTo(self.authorLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-20);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.maskLayer.frame = self.visualEffectView.bounds;
}

//刷新UI
- (void)refreshLayoutFroce{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
