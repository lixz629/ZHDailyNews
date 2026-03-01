//
//  ViewController.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ViewController.h"
#import "AFNetworking.h" //网络请求库
#import "ZHNewsModel.h" //对网络请求数据进行初步处理得到的总model
#import "ZHNewsBannerCell.h" //顶部轮播图的cell
#import "ZHNewsListCell.h" //新闻列表的cell
#import "ZHDateHeaderView.h" //最顶部的日期和问候语
#import "ZHNewsDetailViewController.h" //新闻详情页的vc
#import "Masonry.h" //布局库
#import "MJRefresh.h" //实现刷新效果的库
#import "ZHNewsListDateView.h" //不同日期新闻之间标识日期的view
#import "ZHLoginViewController.h" //登录界面的vc

@interface ViewController ()<SDCycleScrollViewDelegate> //实现轮播图效果的代理方法

@property(nonatomic,strong)ZHNewsModel *latestNewsModel; //总model
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)ZHDateHeaderView *headerView;
@property(nonatomic,strong)NSMutableArray<ZHNewsModel*> *dataArray; //总数据
@property(nonatomic,strong)NSString *currentDate; //当日日期

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataArray];
    [self loadData]; //网络请求
    [self collectionView];
    [self headerView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headerView];
    [self setUpRefresh]; //实现刷新效果
    [self.collectionView.mj_header beginRefreshing]; //初始化时开始刷新
    [self makeViewConstraints]; //布局
}

#pragma mark - 网络请求
-(void)loadData{
    [self collectionView];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //网络接口url
    NSString *urlString = @"https://news-at.zhihu.com/api/4/news/latest";
    //请求数据
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //在子线程处理请求数据
            ZHNewsModel *latestNewsModel = [ZHNewsModel yy_modelWithJSON:responseObject];
            //回到主线程进行赋值和数据源相关操作
            dispatch_async(dispatch_get_main_queue(), ^{
                self.latestNewsModel = latestNewsModel;
                self.currentDate = latestNewsModel.date;
                //清空旧数据 保证数据的实效性
                [self.dataArray removeAllObjects];
                [self.dataArray addObject:self.latestNewsModel];
                [self.headerView settingDate:self.latestNewsModel.date];
                
                //刷新数据
                [self.collectionView reloadData];
                //结束刷新
                [self.collectionView.mj_header endRefreshing];
            });
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //请求失败也结束刷新
        [self.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark - 布局
-(void)makeViewConstraints{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - 刷新
-(void)setUpRefresh{
    //初始化一个经典样式的下拉刷新header 触发下拉刷新时执行loadData方法
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //隐藏最后更新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态文字
    header.stateLabel.hidden = YES;
    self.collectionView.mj_header = header;
    
    //上拉加载更多部分 当触发上拉加载更多时自动执行loadMoreData方法
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    self.collectionView.mj_footer = footer;
}

//获取往日新闻
-(void)loadMoreData{
    [self collectionView];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //往日新闻接口url取决于日期
    NSString *urlString = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/stories/before/%@",self.currentDate];
    //请求数据
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //在子线程处理原始json数据
            ZHNewsModel *beforeNewsModel = [ZHNewsModel yy_modelWithJSON:responseObject];
            //回到主线程进行数据源处理和赋值操作
            dispatch_async(dispatch_get_main_queue(), ^{
                //将往日新闻的日期赋值给currentdate，从而实现每次下拉刷新都能得到前一天新闻的数据
                self.currentDate = beforeNewsModel.date;
                //添加到数据源
                [self.dataArray addObject:beforeNewsModel];
                //要新添加的section索引（前一天的新闻）
                NSInteger newSectionIndex = self.dataArray.count;
                //批量更新数据（更新前一天新闻对应的section）
                [self.collectionView performBatchUpdates:^{
                    //在整个collectionview上插入新的section
                    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:newSectionIndex]];
                } completion:^(BOOL finished) {
                    //上面处理完之后执行结束刷新的操作
                    [self.collectionView.mj_footer endRefreshing];
                }];
            });
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //请求失败也要结束刷新
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - 往期新闻header
//给往期新闻添加日期头header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        static NSString *IDd = @"dateCell";
        ZHNewsListDateView *dateCell = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDd forIndexPath:indexPath];
        //设置日期（自动调用了重写的setter方法将原始数据转化为需要展示的日期）
        dateCell.date = self.dataArray[indexPath.section - 1].date;
        return dateCell;
    }
    return [[UICollectionReusableView alloc]init];
}

//设置日期header大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    //轮播图和当日新闻不显示日期header
    if(section == 0 || section == 1){
        return CGSizeZero;
    }
    return CGSizeMake(self.view.frame.size.width, 30);
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //layOut.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZHNewsBannerCell class] forCellWithReuseIdentifier:@"bannerCell"];
        [_collectionView registerClass:[ZHNewsListCell class] forCellWithReuseIdentifier:@"listCell"];
        [_collectionView registerClass:[ZHNewsListDateView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"dateCell"];
    }
    return _collectionView;
}

- (ZHDateHeaderView *)headerView{
    if(_headerView == nil){
        _headerView = [[ZHDateHeaderView alloc]init];
        __weak typeof(self) weakSelf = self;
        _headerView.loginBlock = ^{
            ZHLoginViewController *loginVc = [[ZHLoginViewController alloc]init];
            [weakSelf.navigationController pushViewController:loginVc animated:YES];
        };
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - 数据源方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count + 1; //新闻cell+轮播图cell
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return 1; //轮播图
    }else{
        return self.dataArray[section - 1].stories.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *IDb = @"bannerCell";
        ZHNewsBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDb forIndexPath:indexPath];
        //设置数据
        cell.bannerData = self.latestNewsModel.top_stories;
        //点击轮播图图片实现跳转的block代码块
        cell.clickBannerItemBlock = ^(NSInteger index) {
            //获取数据
            ZHNewsTopStories *bannerModel = self.latestNewsModel.top_stories[index];
            
            //跳转后需要展示的新闻详情页vc
            ZHNewsDetailViewController *detailVc = [[ZHNewsDetailViewController alloc]init];
            //获取model里的新闻id属性，确定要跳转的具体新闻url
            detailVc.newsID = bannerModel.id;
            //执行跳转
            [self.navigationController pushViewController:detailVc animated:YES];
        };
        return cell;
    }else{
        static NSString *ID = @"listCell";
        ZHNewsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.stories = self.dataArray[indexPath.section - 1].stories[indexPath.row];
        cell.backgroundColor = [UIColor systemBackgroundColor]; //适配黑暗模式
        return cell;
    }
}

#pragma mark - FlowLayout代理方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 1.0);
    }else{
        return CGSizeMake(self.view.frame.size.width, 100);
    }
}

#pragma mark - delegate代理方法
//点击新闻cell实现跳转
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //获取数据
    ZHNewsStories *storiesModel = self.dataArray[indexPath.section - 1].stories[indexPath.row];
    //记录新闻是否已经点开阅读过
    storiesModel.isRead = YES;
    //刷新被点击的新闻cell的状态（已经阅读过的新闻变灰）
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
   
    //新闻详情页vc
    ZHNewsDetailViewController *detailVc = [[ZHNewsDetailViewController alloc]init];
    //获取新闻id
    detailVc.newsID = storiesModel.id;
    //跳转
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
