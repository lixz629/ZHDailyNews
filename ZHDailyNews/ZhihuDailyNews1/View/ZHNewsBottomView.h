//
//  ZHNewsBottomView.h
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZHNewsBottomViewDelegate <NSObject>

-(void)clickReturn;

-(void)clickComment;

-(void)clickLike;

-(void)clickCollect;

-(void)clickShare;

@end

@interface ZHNewsBottomView : UIView

@property(nonatomic,weak)id<ZHNewsBottomViewDelegate> delegate;
@property(nonatomic,strong)UIButton *returnButton;
@property(nonatomic,strong)UIButton *commentButton;
@property(nonatomic,strong)UIButton *likeButton;
@property(nonatomic,strong)UIButton *collectButton;
@property(nonatomic,strong)UIButton *shareButton;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)UILabel *likeLabel;

@end

NS_ASSUME_NONNULL_END
