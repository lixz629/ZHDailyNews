//
//  ZHDateHeaderView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/11.
//

#import "ZHDateHeaderView.h"

@implementation ZHDateHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.dayLabel = [[UILabel alloc]init];
        self.monthLabel = [[UILabel alloc]init];
        self.greetLabel = [[UILabel alloc]init];
        self.lineView = [[UIView alloc]init];
        [self makeConstraints];
        [self settingGreeting:self.greetLabel];
    }
    return self;
}

-(void)makeConstraints{
    
}

- (void)settingDate:(NSString *)dateString{
    NSDateFormatter *temp = [[NSDateFormatter alloc]init];
    temp.dateFormat = @"yyyyMMdd";
    NSDate *date = [temp dateFromString:dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd";
    NSString *day = [dateFormatter stringFromDate:date];
    self.dayLabel.text = day;
    self.dayLabel.font = [UIFont boldSystemFontOfSize:27];
    
    dateFormatter.dateFormat = @"MMMM";
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSString *month = [dateFormatter stringFromDate:date];
    self.monthLabel.text = month;
    self.monthLabel.font = [UIFont systemFontOfSize:20];
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
}

@end
