//
//  topView.m
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/6.
//

#import "topView.h"

@implementation topView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        CGFloat padding = 30;
        self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, 45, 60, 40)];
        [self addSubview:self.dayLabel];
        self.monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding, 80, 200, 30)];
        [self addSubview:self.monthLabel];
        self.greetLabel = [[UILabel alloc]initWithFrame:CGRectMake(30 + padding * 2.5, padding * 1.8, self.frame.size.width - 60 - padding * 4, 50)];
        [self settingGreeting:self.greetLabel];
        self.greetLabel.font = [UIFont boldSystemFontOfSize:35];
        [self addSubview:self.greetLabel];
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(30 + padding * 1.93, padding * 1.5, 0.5, 70)];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
    }
    return self;
}

-(void)settingDate:(NSString *)dateString{
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
    self.monthLabel.font = [UIFont systemFontOfSize:22];
}

-(void)settingGreeting:(UILabel *)greetLabel{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger hour = [calendar component:NSCalendarUnitHour fromDate:currentDate];
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
}

@end
