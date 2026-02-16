//
//  ViewController.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/8.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "ZHLatestNewsModel.h"
#import "ZHNewsBannerCell.h"
#import "ZHNewsListCell.h"
#import "ZHDateHeaderView.h"
#import "ZHNewsDetailViewController.h"
#import "Masonry.h"
#import "MJRefresh.h"

@interface ViewController ()<SDCycleScrollViewDelegate>

@property(nonatomic,strong)ZHLatestNewsModel *latestNewsModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)ZHDateHeaderView *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self collectionView];
    [self.view addSubview:self.collectionView];
    [self headerView];
    [self.view addSubview:self.headerView];
    [self setUpRefresh];
    [self.collectionView.mj_header beginRefreshing];
    [self makeViewConstraints];
}

-(void)loadData{
    [self collectionView];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"https://news-at.zhihu.com/api/4/news/latest";
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHLatestNewsModel *latestNewsModel = [ZHLatestNewsModel yy_modelWithJSON:responseObject];
        self.latestNewsModel = latestNewsModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerView settingDate:self.latestNewsModel.date];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.collectionView.mj_header endRefreshing];
    }];
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layOut.sectionHeadersPinToVisibleBounds = YES;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZHNewsBannerCell class] forCellWithReuseIdentifier:@"bannerCell"];
        [_collectionView registerClass:[ZHNewsListCell class] forCellWithReuseIdentifier:@"listCell"];
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return self.latestNewsModel.stories.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *IDb = @"bannerCell";
        ZHNewsBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDb forIndexPath:indexPath];
        cell.bannerData = self.latestNewsModel.top_stories;
        cell.clickItemBlock = ^(NSInteger index) {
            ZHLatestNewsTopStories *bannerModel = self.latestNewsModel.top_stories[index];
            ZHNewsDetailViewController *detailVc = [[ZHNewsDetailViewController alloc]init];
            detailVc.newsID = bannerModel.id;
            [self.navigationController pushViewController:detailVc animated:YES];
        };
        return cell;
    }else{
        static NSString *ID = @"listCell";
        ZHNewsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.stories = self.latestNewsModel.stories[indexPath.row];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * 1.0);
    }else{
        return CGSizeMake(self.view.frame.size.width, 100);
    }
}

- (ZHDateHeaderView *)headerView{
    if(_headerView == nil){
        _headerView = [[ZHDateHeaderView alloc]init];
    }
    return _headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHLatestNewsStories *storiesModel = self.latestNewsModel.stories[indexPath.row];
    ZHNewsDetailViewController *detailVc = [[ZHNewsDetailViewController alloc]init];
    detailVc.newsID = storiesModel.id;
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(void)makeViewConstraints{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ZHLatestNewsTopStories *bannerModel = self.latestNewsModel.top_stories[index];
    ZHNewsDetailViewController *detailVc = [[ZHNewsDetailViewController alloc]init];
    detailVc.newsID = bannerModel.id;
    [self.navigationController pushViewController:detailVc animated:YES];
}

-(void)setUpRefresh{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.collectionView.mj_header = header;
}

@end
