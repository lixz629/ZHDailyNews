//
//  ZHLoginMainView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/21.
//

#import "ZHLoginMainView.h"
#import "Masonry.h" //自动布局库

@implementation ZHLoginMainView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        //初始化并添加到子视图上
        self.loginLabel = [[UILabel alloc]init];
        self.loginStyleLabel = [[UILabel alloc]init];
        self.ZHbutton = [[UIButton alloc]init];
        self.WBbutton = [[UIButton alloc]init];
        self.stateButton = [[UIButton alloc]init];
        [self addSubview:self.loginLabel];
        [self addSubview:self.loginStyleLabel];
        [self addSubview:self.ZHbutton];
        [self addSubview:self.WBbutton];
        [self addSubview:self.stateButton];
        
        //布局
        [self makeConstraints];
        //设置相关数据
        [self settingData];
        
        //添加点击事件
        [self.ZHbutton addTarget:self action:@selector(clickZH) forControlEvents:UIControlEventTouchUpInside];
        [self.WBbutton addTarget:self action:@selector(clickWB) forControlEvents:UIControlEventTouchUpInside];
        [self.stateButton addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)makeConstraints{
    //“登录知乎日报”
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
    }];
    
    //“选择登录方式”
    [self.loginStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginLabel.mas_bottom).offset(13);
        make.centerX.equalTo(self);
    }];
    
    //知乎按钮
    [self.ZHbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginStyleLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self).offset(-40);
        make.width.height.mas_equalTo(60);
    }];
    
    //微博按钮
    [self.WBbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ZHbutton);
        make.centerX.equalTo(self).offset(40);
        make.width.height.mas_equalTo(60);
    }];
    
    //同意按钮
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ZHbutton.mas_bottom).offset(20);
        make.left.equalTo(self).offset(35);
        make.height.width.mas_equalTo(40);
        make.bottom.equalTo(self);
    }];
}

-(void)settingData{
    self.loginLabel.text = @"登陆知乎日报";
    self.loginLabel.font = [UIFont boldSystemFontOfSize:27];
    self.loginLabel.textColor = [UIColor labelColor];
    self.loginStyleLabel.text = @"选择登录方式";
    self.loginStyleLabel.font = [UIFont systemFontOfSize:20];
    self.loginStyleLabel.textColor = [UIColor secondaryLabelColor];
    
    //设置按钮图片
    [self.ZHbutton setImage:[UIImage imageNamed:@"zhihu"] forState:UIControlStateNormal];
    [self.WBbutton setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
    
    //设置未点击时（normal）的图片
    [self.stateButton setImage:[UIImage imageNamed:@"normalStyle"] forState:UIControlStateNormal];
    //设置点击后（selected）的图片
    [self.stateButton setImage:[UIImage imageNamed:@"selectedStyle"] forState:UIControlStateSelected];
}

-(void)clickZH{
    if(self.clickZHBlock){
        self.clickWBBlock();
    }
}

-(void)clickWB{
    if(self.clickWBBlock){
        self.clickWBBlock();
    }
}

-(void)changeState{
    //点击后切换选中状态（切换显示图片）
    self.stateButton.selected = !self.stateButton.selected;
    //执行block代码块（在viewcontroller里实现相关功能）
    if(self.changeStateBlock){
        self.changeStateBlock();
    }
}

@end
