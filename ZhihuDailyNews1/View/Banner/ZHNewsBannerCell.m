//
//  ZHNewsBannerCell.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ZHNewsBannerCell.h"
#import "ZHNewsBannerInnerCell.h"
#import "SDWebImage.h" //异步图片下载和缓存库

@implementation ZHNewsBannerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        //初始化并设置大小为整个bannercell 代理为self 占位图为nil
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:nil];
        //将轮播图底部小圆点位置设置在右下角
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //设置自动切换图片时间
        self.cycleScrollView.autoScrollTimeInterval = 3.0;
        //设置标题文字底部背景条的颜色
        self.cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cycleScrollView];
    }
    return self;
}

//重写bannerdata的setter方法
- (void)setBannerData:(NSArray<ZHNewsTopStories *> *)bannerData{
    //将传入的bannerdata赋值给_bannerdata成员变量
    _bannerData = bannerData;
    //遍历bannerData，把top_stories里的所有图片url存到一个数组里方便调用数据
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (ZHNewsTopStories *topStories in _bannerData) {
        if(topStories.image){
            [imageUrls addObject:topStories.image];
        }
    }
    //将上面遍历得到的图片url数组传给cycleScrollView
    self.cycleScrollView.imageURLStringsGroup = imageUrls;
}

//将轮播图展示的cell设置为自定义cell便于还原原版知乎日报的设计风格
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view{
    return [ZHNewsBannerInnerCell class];
}

//为自定义cell填充数据
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    ZHNewsBannerInnerCell *innerCell = (ZHNewsBannerInnerCell*)cell;
    //获取每张图片对应的model
    ZHNewsTopStories *model = self.bannerData[index];
    
    //赋值
    innerCell.titleLabel.text = model.title;
    innerCell.titleLabel.numberOfLines = 2;
    innerCell.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    //为标题文字设置阴影效果增强可读性
    innerCell.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:1.0];
    innerCell.titleLabel.shadowOffset = CGSizeMake(0, 1);
    innerCell.titleLabel.textColor = [UIColor whiteColor];
    
    innerCell.hintLabel.text = model.hint;
    innerCell.hintLabel.font = [UIFont boldSystemFontOfSize:20];
    innerCell.hintLabel.textColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    //阴影
    innerCell.hintLabel.shadowColor = [UIColor colorWithWhite:0 alpha:1.0];
    innerCell.hintLabel.shadowOffset = CGSizeMake(0, 1);
    
    //调用SDWebImage库的方法下载图片并显示
    [innerCell.imgView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    //刷新UI尺寸，正确显示遮罩层
    [innerCell refreshLayoutForce];
}

//点击轮播图跳转到对应新闻页面的方法（具体跳转逻辑在ViewController里）
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if(self.clickBannerItemBlock){
        self.clickBannerItemBlock(index);
    }
}

@end
