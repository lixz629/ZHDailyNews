//
//  ZHNewsBottomView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/14.
//

//新闻详情页底部的工具栏
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//声明代理协议
@protocol ZHNewsBottomViewDelegate <NSObject>

//五个点击事件
-(void)clickReturn;

-(void)clickComment;

-(void)clickLike;

-(void)clickCollect;

-(void)clickShare;

@end

@interface ZHNewsBottomView : UIView

//声明delegate属性
@property(nonatomic,weak)id<ZHNewsBottomViewDelegate> delegate;

@property(nonatomic,strong)UIButton *returnButton; //返回键
@property(nonatomic,strong)UIButton *commentButton; //评论
@property(nonatomic,strong)UIButton *likeButton; //点赞
@property(nonatomic,strong)UIButton *collectButton; //收藏
@property(nonatomic,strong)UIButton *shareButton; //分享
@property(nonatomic,strong)UIView *lineView; //分隔线
@property(nonatomic,strong)UILabel *commentLabel; //评论数
@property(nonatomic,strong)UILabel *likeLabel; //点赞数

@end

NS_ASSUME_NONNULL_END
