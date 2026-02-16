//
//  ZHNewsBannerCell.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ZHNewsBannerCell.h"
#import "ZHNewsBannerInnerCell.h"
#import "SDWebImage.h"

@implementation ZHNewsBannerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:nil];
        self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.cycleScrollView.autoScrollTimeInterval = 3.0;
        self.cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.cycleScrollView];
    }
    return self;
}

- (void)setBannerData:(NSArray<ZHLatestNewsTopStories *> *)bannerData{
    _bannerData = bannerData;
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (ZHLatestNewsTopStories *topStories in _bannerData) {
        if(topStories.image){
            [imageUrls addObject:topStories.image];
        }
    }
    self.cycleScrollView.imageURLStringsGroup = imageUrls;
}

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view{
    return [ZHNewsBannerInnerCell class];
}
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    ZHNewsBannerInnerCell *innerCell = (ZHNewsBannerInnerCell*)cell;
    ZHLatestNewsTopStories *model = self.bannerData[index];
    innerCell.titleLabel.text = model.title;
    innerCell.titleLabel.numberOfLines = 2;
    innerCell.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    innerCell.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:1.0];
    innerCell.titleLabel.shadowOffset = CGSizeMake(0, 1);
    innerCell.titleLabel.textColor = [UIColor whiteColor];
    innerCell.hintLabel.text = model.hint;
    innerCell.hintLabel.font = [UIFont boldSystemFontOfSize:20];
    innerCell.hintLabel.textColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
    innerCell.hintLabel.shadowColor = [UIColor colorWithWhite:0 alpha:1.0];
    innerCell.hintLabel.shadowOffset = CGSizeMake(0, 1);
    [innerCell.imgView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    [innerCell refreshLayoutForce];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if(self.clickItemBlock){
        self.clickItemBlock(index);
    }
}

@end
