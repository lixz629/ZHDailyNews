//
//  ZHNewsBannerInnerCell.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/10.
//

#import "ZHNewsBannerInnerCell.h"
#import "Masonry.h"//布局

@implementation ZHNewsBannerInnerCell

//重写init方法
- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.imgView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.hintLabel = [[UILabel alloc]init];
        
        //模糊效果（系统材质黑）
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialDark];
        //将上面的模糊效果设置给.h文件中声明的遮罩层view
        self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        //渐变模糊层的具体实现
        //先创建一个处理颜色渐变的图层layer
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        //设置渐变图层所包含的颜色数组
        //获取对应颜色的CGColor指针并转换为对象类型（id）
        maskLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor blackColor].CGColor];
        //设置上面渐变图层所包含的颜色渐变的停止点
        maskLayer.locations = @[@0.0,@0.2];
        //将上面的渐变图层应用到visualEffectView的图层layer上
        self.visualEffectView.layer.mask = maskLayer;
        //调整不透明度（避免某些位置文字不清晰）
        self.visualEffectView.alpha = 0.6;
        [self.contentView addSubview:self.visualEffectView];
        //将标题和作者信息加在遮罩层visualEffectView的contentView上，实现遮罩效果
        [self.visualEffectView.contentView addSubview:self.titleLabel];
        [self.visualEffectView.contentView addSubview:self.hintLabel];
        //布局
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    //图片
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    //遮罩层
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView).multipliedBy(0.4);
    }];
    
    //作者信息
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.right.offset(-20);
        make.bottom.offset(-25);
    }];
    
    //新闻标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.hintLabel);
        make.bottom.equalTo(self.hintLabel.mas_top).offset(-8);
    }];
}

//更新UI布局
-(void)refreshLayoutForce{
    //打一个需要更新的标记
    [self setNeedsLayout];
    //强制立即更新UI
    [self layoutIfNeeded];
    //在这里设置遮罩层的尺寸，避免出现遮罩层没有尺寸的问题
    self.visualEffectView.layer.mask.frame = self.visualEffectView.bounds;
}

@end
