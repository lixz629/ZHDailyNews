//
//  ZHNewsBottomView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/14.
//

#import "ZHNewsBottomView.h"
#import "Masonry.h"

@implementation ZHNewsBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.returnButton = [[UIButton alloc]init];
        [self addSubview:self.returnButton];
        self.commentButton = [[UIButton alloc]init];
        [self addSubview:self.commentButton];
        self.likeButton = [[UIButton alloc]init];
        [self addSubview:self.likeButton];
        self.collectButton = [[UIButton alloc]init];
        [self addSubview:self.collectButton];
        self.shareButton = [[UIButton alloc]init];
        [self addSubview:self.shareButton];
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
        self.commentLabel = [[UILabel alloc]init];
        self.commentLabel.textColor = [UIColor blackColor];
        self.commentLabel.font = [UIFont systemFontOfSize:12];
        [self.commentButton addSubview:self.commentLabel];
        self.likeLabel = [[UILabel alloc]init];
        self.likeLabel.textColor = [UIColor blackColor];
        self.likeLabel.font = [UIFont systemFontOfSize:12];
        [self.likeButton addSubview:self.likeLabel];
        [self makeConstraints];
        [self settingImages];
        [self.returnButton addTarget:self action:@selector(clickReturn) forControlEvents:UIControlEventTouchUpInside];
        [self.commentButton addTarget:self action:@selector(clickComment) forControlEvents:UIControlEventTouchUpInside];
        [self.likeButton addTarget:self action:@selector(clickLike) forControlEvents:UIControlEventTouchUpInside];
        [self.collectButton addTarget:self action:@selector(clickCollect) forControlEvents:UIControlEventTouchUpInside];
        [self.shareButton addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)makeConstraints{
    NSArray *buttons = @[self.returnButton,self.commentButton,self.likeButton,self.collectButton,self.shareButton];
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = self.frame.size.width / 5;
        make.left.equalTo(self.commentButton).offset(offset);
        make.height.equalTo(self.commentButton);
        make.width.mas_equalTo(1);
        make.top.equalTo(self.commentButton);
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.commentButton.mas_centerX).offset(25);
        make.centerY.equalTo(self.commentButton.mas_centerY).offset(-10);
    }];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.likeButton.mas_centerX).offset(25);
        make.centerY.equalTo(self.likeButton.mas_centerY).offset(-10);
    }];
}

-(void)settingImages{
    [self.returnButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.returnButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    self.commentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"likeSuccess"] forState:UIControlStateSelected];
    self.likeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"collectSuccess"] forState:UIControlStateSelected];
    self.collectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    self.shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)clickReturn{
    if([self.delegate respondsToSelector:@selector(clickReturn)]){
        [self.delegate clickReturn];
    }
}

-(void)clickComment{
    if([self.delegate respondsToSelector:@selector(clickComment)]){
        [self.delegate clickComment];
    }
}

-(void)clickLike{
    self.likeButton.selected = !self.likeButton.selected;
    if([self.delegate respondsToSelector:@selector(clickLike)]){
        [self.delegate clickLike];
    }
}

-(void)clickCollect{
    self.collectButton.selected = !self.collectButton.selected;
    if([self.delegate respondsToSelector:@selector(clickCollect)]){
        [self.delegate clickCollect];
    }
}

-(void)clickShare{
    if([self.delegate respondsToSelector:@selector(clickShare)]){
        [self.delegate clickShare];
    }
}

@end
