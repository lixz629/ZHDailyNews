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

@interface ViewController ()

@property(nonatomic,strong)ZHLatestNewsModel *latestNewsModel;
@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self collectionView];
    [self.view addSubview:self.collectionView];
}

-(void)loadData{
    [self collectionView];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"https://news-at.zhihu.com/api/4/news/latest";
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZHLatestNewsModel *latestNewsModel = [ZHLatestNewsModel yy_modelWithJSON:responseObject];
        self.latestNewsModel = latestNewsModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewCompositionalLayout *layOut = [[UICollectionViewCompositionalLayout alloc]initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {
            if(sectionIndex == 0){
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.0]];
                NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension absoluteDimension:400]];
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
                NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
                section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorPaging;
                return section;
            }
            else{
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension absoluteDimension:96]];
                                                    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0] heightDimension:[NSCollectionLayoutDimension absoluteDimension:104]];
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitems:@[item]];
                NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
                return section;
            }
        }];
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layOut];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ZHNewsBannerCell class] forCellWithReuseIdentifier:@"bannerCell"];
        [_collectionView registerClass:[ZHNewsListCell class] forCellWithReuseIdentifier:@"listCell"];
        [_collectionView registerClass:[ZHDateHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyView"];
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
        return CGSizeMake(self.view.frame.size.width, 390);
    }else{
        return CGSizeMake(self.view.frame.size.width, 100);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDh = @"header";
    if([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 1){
        ZHDateHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDh forIndexPath:indexPath];
        [headerView settingDate:self.latestNewsModel.date];
        return headerView;
    }else{
        UICollectionReusableView *emptyView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"emptyView" forIndexPath:indexPath];
        return emptyView;
    }
}

@end
