//
//  ZHDateHeaderView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import "ZHDateHeaderView.h"
#import "Masonry.h"

@implementation ZHDateHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.dayLabel = [[UILabel alloc]init];
        self.monthLabel = [[UILabel alloc]init];
        self.greetLabel = [[UILabel alloc]init];
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.dayLabel];
        [self addSubview:self.monthLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.greetLabel];
        [self makeConstraints];
        [self settingGreeting:self.greetLabel];
    }
    return self;
}

-(void)makeConstraints{
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self).offset(20);
    }];
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.dayLabel);
        make.bottom.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLabel.mas_right).offset(20);
        make.bottom.equalTo(self.monthLabel);
        make.top.equalTo(self.dayLabel);
        make.width.mas_equalTo(1.0);
    }];
    [self.greetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(15);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(13);
        make.bottom.equalTo(self).offset(-13);
    }];
}

- (void)settingDate:(NSString *)dateString{
    NSDateFormatter *temp = [[NSDateFormatter alloc]init];
    temp.dateFormat = @"yyyyMMdd";
    NSDate *date = [temp dateFromString:dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd";
    NSString *day = [dateFormatter stringFromDate:date];
    self.dayLabel.text = day;
    self.dayLabel.font = [UIFont boldSystemFontOfSize:30];
    
    dateFormatter.dateFormat = @"MMMM";
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSString *month = [dateFormatter stringFromDate:date];
    self.monthLabel.text = month;
    self.monthLabel.font = [UIFont systemFontOfSize:16];
}

-(void)settingGreeting:(UILabel *)greetLabel{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger hour = [calender component:NSCalendarUnitHour fromDate:currentDate];
    if(hour >= 0 && hour <= 6){
        greetLabel.text = @"早点休息～";
    }else if (hour > 6 && hour <= 11){
        greetLabel.text = @"早上好～";
    }else if (hour > 11 && hour <= 13){
        greetLabel.text = @"中午好～";
    }else if (hour > 13 && hour <= 18){
        greetLabel.text = @"下午好～";
    }else{
        greetLabel.text = @"晚上好～";
    }
    greetLabel.font = [UIFont boldSystemFontOfSize:32];
}

@end
