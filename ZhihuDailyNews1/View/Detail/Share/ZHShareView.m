//
//  ZHShareView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/23.
//

#import "ZHShareView.h"
#import "Masonry.h"
#import "ZHShareCell.h"

@interface ZHShareView()<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong)UIView *contentView; //显示内容
@property(nonatomic,copy)void(^completionBlock)(NSInteger); //block代码块
@property(nonatomic,strong)UICollectionViewFlowLayout *layOut;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *firstRowData; //第一行的图片数据
@property(nonatomic,strong)NSArray *secondRowData; //第二行的图片数据

@end

@implementation ZHShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//分享方法
+ (void)showWithcompletion:(void (^)(NSInteger))completion{
    //初始化一个shareView并铺满全屏
    ZHShareView *shareView =[[ZHShareView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //保存外部传入的代码块
    shareView.completionBlock = completion;
    //将shareView添加到整个app最顶层的窗口（弹窗效果）
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    //调用内部展示方法
    [shareView animatedShow];
}

//重写init方法
- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0]; //完全透明的黑色背景
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 300)];
        self.contentView.backgroundColor = [UIColor systemBackgroundColor];
        self.contentView.layer.cornerRadius = 15; //设置圆角效果
        [self addSubview:self.contentView];
        
        //懒加载
        [self firstRowData];
        [self secondRowData];
        [self layOut];
        [self collectionView];
        
        [self.contentView addSubview:self.collectionView];
        [self makeConstraints];
        
        //监听点击手势 实现点击空白处收起弹窗的效果
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//弹出弹窗
-(void)animatedShow{
    //在执行后的0.3s内执行代码块里的动画代码（弹窗弹出的效果）
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.contentView.frame = CGRectMake(0, self.frame.size.height - 250, self.frame.size.width, 250);
    }];
}

//点击空白处收起弹窗
-(void)handleTap:(UITapGestureRecognizer *)sender{
    //获取点击的位置
    CGPoint point = [sender locationInView:self];
    //当点击空白位置时执行收起代码
    if(!CGRectContainsPoint(self.contentView.frame, point)){
        [self animateHide];
    }
}

//收起弹窗
-(void)animateHide{
    //方法执行后0.3s内执行收起代码
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
        self.contentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 250);
    } completion:^(BOOL finished) {
        //上面的收起动画结束后将藏在屏幕底部的分享栏移除
        [self removeFromSuperview];
    }];
}

//布局
-(void)makeConstraints{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - 懒加载

- (UICollectionViewFlowLayout *)layOut{
    if(_layOut == nil){
        _layOut = [[UICollectionViewFlowLayout alloc]init];
        CGFloat sectionMargin = 15.0;
        CGFloat itemSpacing = 10.0;
        //同一行相邻两个cell间的最小间距
        _layOut.minimumInteritemSpacing = itemSpacing;
        //最小行间距
        _layOut.minimumLineSpacing = 20.0;
        //设置整个分区的内边距
        _layOut.sectionInset = UIEdgeInsetsMake(0, sectionMargin, 0, sectionMargin);
        CGFloat totalWidth = self.frame.size.width - sectionMargin * 2;
        CGFloat itemWidth = (totalWidth - itemSpacing * 3) / 4;
        //设置每个cell的大小
        _layOut.itemSize = CGSizeMake(itemWidth, 100);
    }
    return _layOut;
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layOut];
        _collectionView.delegate = self; //设置代理
        _collectionView.dataSource = self; //设置数据源
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO; //隐藏水平导航条
        _collectionView.scrollEnabled = NO; //禁止滚动
        //注册自定义cell
        [_collectionView registerClass:[ZHShareCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSArray *)firstRowData{
    if(_firstRowData == nil){
        _firstRowData = @[
            @{@"image":@"weixin",@"text":@"微信好友"},
            @{@"image":@"friendsCircle",@"text":@"朋友圈"},
            @{@"image":@"weibo",@"text":@"新浪微博"},
            @{@"image":@"QQ",@"text":@"QQ"}];
    }
    return _firstRowData;
}

- (NSArray *)secondRowData{
    if(_secondRowData == nil){
        _secondRowData = @[
            @{@"image":@"copyLink",@"text":@"复制链接"},
            @{@"image":@"openBrowser",@"text":@"浏览器打开"},
            @{@"image":@"moreData",@"text":@"更多"}];
    }
    return _secondRowData;
}

#pragma mark - 数据源方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return 4;
    }else{
        return 3;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    if(indexPath.section == 0){
        ZHShareCell *firstRowCell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        [firstRowCell updateWithData:self.firstRowData[indexPath.item]];
        return firstRowCell;
    }else{
        ZHShareCell *secondCell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        [secondCell updateWithData:self.secondRowData[indexPath.item]];
        return secondCell;
    }
}

#pragma mark - 代理方法

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = indexPath.item;
    if(indexPath.section > 0){
        index += self.firstRowData.count;
    }
    //将index传回viewController
    if(self.completionBlock){
        self.completionBlock(index);
    }
    [self animateHide];
}

@end
