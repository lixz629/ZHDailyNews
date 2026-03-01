//
//  ZHNewsListDateView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/20.
//

#import "ZHNewsListDateView.h"
#import "Masonry.h" //布局

@implementation ZHNewsListDateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//重写init方法
- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.dateLabel = [[UILabel alloc]init];
        self.lineView = [[UIView alloc]init];
        [self addSubview:self.dateLabel];
        [self addSubview: self.lineView];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    //日期
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    //分隔线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(20);
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

//重写date的setter方法
- (void)setDate:(NSString *)date{
    _date = date;
    [self settingData];
}

//赋值方法
-(void)settingData{
    //将字符串日期转换为NSDate类型
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    tempFormatter.dateFormat = @"yyyyMMdd";
    NSDate *Date = [tempFormatter dateFromString:self.date];
    
    //转换为需要展示的字符串
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"M月d日";
    NSString *dateText = [dateFormatter stringFromDate:Date];
    
    //赋值
    self.dateLabel.text = dateText;
    self.dateLabel.textColor = [UIColor secondaryLabelColor];
    self.dateLabel.font = [UIFont systemFontOfSize:17];
    
    self.lineView.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
}


@end
