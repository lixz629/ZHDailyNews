//
//  ZHNewsBottomView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/14.
//

#import "ZHNewsBottomView.h"
#import "Masonry.h" //布局

@implementation ZHNewsBottomView

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
        self.returnButton = [[UIButton alloc]init];
        self.commentButton = [[UIButton alloc]init];
        self.likeButton = [[UIButton alloc]init];
        self.collectButton = [[UIButton alloc]init];
        self.shareButton = [[UIButton alloc]init];
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.returnButton];
        [self addSubview:self.commentButton];
        [self addSubview:self.likeButton];
        [self addSubview:self.collectButton];
        [self addSubview:self.shareButton];
        [self addSubview:self.lineView];
        
        self.commentLabel = [[UILabel alloc]init];
        //设置字体颜色为语义化颜色 便于适配夜间模式
        self.commentLabel.textColor = [UIColor secondaryLabelColor];
        self.commentLabel.font = [UIFont systemFontOfSize:12];
        [self.commentButton addSubview:self.commentLabel];
        
        self.likeLabel = [[UILabel alloc]init];
        self.likeLabel.textColor = [UIColor secondaryLabelColor];
        self.likeLabel.font = [UIFont systemFontOfSize:12];
        [self.likeButton addSubview:self.likeLabel];
        
        //布局
        [self makeConstraints];
        //设置按键图片
        [self settingImages];
        
        //添加点击事件
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
    //将五个按钮按上面数组里的顺序在水平方向上均匀布局
    [buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        //底部和安全区域重合，避免误触
        make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
    }];
    //分隔线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = self.frame.size.width / 5;
        make.left.equalTo(self.commentButton).offset(offset);
        make.height.equalTo(self.commentButton);
        make.width.mas_equalTo(1);
        make.top.equalTo(self.commentButton);
    }];
    
    //评论数
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.commentButton.mas_centerX).offset(25);
        make.centerY.equalTo(self.commentButton.mas_centerY).offset(-10);
    }];
    
    //点赞数
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.likeButton.mas_centerX).offset(25);
        make.centerY.equalTo(self.likeButton.mas_centerY).offset(-10);
    }];
}

//设置图片
-(void)settingImages{
    [self.returnButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    //等比缩放显示，保证按钮图案完整
    self.returnButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //将按钮图片（template）颜色也设置为语义色，便于适配黑夜模式
    self.returnButton.tintColor = [UIColor secondaryLabelColor];
    
    [self.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    self.commentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.commentButton.tintColor = [UIColor secondaryLabelColor];
    
    [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"likeSuccess"] forState:UIControlStateSelected];
    self.likeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.likeButton.tintColor = [UIColor secondaryLabelColor];
    
    [self.collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [self.collectButton setImage:[UIImage imageNamed:@"collectSuccess"] forState:UIControlStateSelected];
    self.collectButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.collectButton.tintColor = [UIColor secondaryLabelColor];
    
    [self.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    self.shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.shareButton.tintColor = [UIColor secondaryLabelColor];
}

-(void)clickReturn{
    //判断该方法在delegate（viewcontroller）里是否实现
    if([self.delegate respondsToSelector:@selector(clickReturn)]){
        //如果实现后才让delegate执行该点击方法
        [self.delegate clickReturn];
    }
}

-(void)clickComment{
    if([self.delegate respondsToSelector:@selector(clickComment)]){
        [self.delegate clickComment];
    }
}

-(void)clickLike{
    //点击后将选中状态切换（实现图片间的切换）
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
