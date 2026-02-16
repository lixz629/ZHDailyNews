//
//  ViewController.m
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/3.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "Newsitem.h"
#import "ItemCell.h"
#import "topView.h"
#import "topStoriesItem.h"
#import "bannerView.h"

@interface ViewController ()

@property(nonatomic,strong)Newsitem *item;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)topView *topView;
@property(nonatomic,strong)topStoriesItem *topItem;
@property(nonatomic,strong)bannerView *bannerView;
@property(nonatomic,strong)NSMutableArray *topDataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self collectionView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
}

-(NSArray *)loadData{
    [self dataArray];
    [self topView];
    [self topDataArray];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"https://news-at.zhihu.com/api/4/news/latest";
    [manager GET:urlString parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //NSLog(@"请求成功");
        
        NSString *dateString = responseObject[@"date"];
        [self.topView settingDate:dateString];
        
        NSArray *storiesArray = responseObject[@"stories"];
        for (NSDictionary *dict in storiesArray) {
            Newsitem *item = [Newsitem itemWithDict:dict];
            [self.dataArray addObject:item];
        }
        
        NSArray *topStoriesArray = responseObject[@"top_stories"];
        for (NSDictionary *dict in topStoriesArray) {
            topStoriesItem *topItem = [topStoriesItem itemWithDict:dict];
            [self.topDataArray addObject:topItem];
        }
        
        [self.collectionView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    return self.dataArray;
}

- (NSArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        layOut.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layOut];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[bannerView class] forCellWithReuseIdentifier:@"bannerView"];
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
        return self.dataArray.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    static NSString *IDb = @"bannerView";
    if(indexPath.section == 0){
        bannerView *bannerView = [collectionView dequeueReusableCellWithReuseIdentifier:IDb forIndexPath:indexPath];
        bannerView.backgroundColor = [UIColor whiteColor];
        topStoriesItem *topItem = self.topDataArray[indexPath.row];
        return bannerView;
    }else{
        ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        Newsitem *item = self.dataArray[indexPath.row];
        cell.item = item;
        return cell;
    }
}

- (UIView *)topView{
    if(_topView == nil){
        _topView = [[topView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    }
    return _topView;
}

- (NSMutableArray *)topDataArray{
    if(_topDataArray == nil){
        _topDataArray = [[NSMutableArray alloc]init];
    }
    return _topDataArray;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return CGSizeMake(self.view.frame.size.width, 400);
    }else{
        return CGSizeMake(self.view.frame.size.width, 100);
    }
}

@end
