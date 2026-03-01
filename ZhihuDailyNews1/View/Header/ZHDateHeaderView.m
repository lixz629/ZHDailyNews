//
//  ZHDateHeaderView.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import "ZHDateHeaderView.h"
#import "Masonry.h" //自动布局库 用于实现机型适配

@implementation ZHDateHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        //初始化并添加到子视图
        self.dayLabel = [[UILabel alloc]init];
        self.monthLabel = [[UILabel alloc]init];
        self.greetLabel = [[UILabel alloc]init];
        self.lineView = [[UIView alloc]init];
        self.loginButton = [[UIButton alloc]init];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.dayLabel];
        [self addSubview:self.monthLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.greetLabel];
        [self addSubview:self.loginButton];
        
        //设置默认头像
        [self.loginButton setImage:[UIImage imageNamed:@"loginPhoto"] forState:UIControlStateNormal];
        //添加登录的点击事件
        [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        //布局方法
        [self makeConstraints];
        //根据当前时间设置相应的问候语
        [self settingGreeting:self.greetLabel];
    }
    return self;
}

//布局代码
-(void)makeConstraints{
    //日期
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //safeAreaLayoutGuideTop 安全区域 根据这个参数可以适配灵动岛及全面屏iPhone
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self).offset(20);
    }];
    
    //月份
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dayLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.dayLabel);
        make.bottom.equalTo(self);
    }];
    
    //分隔线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayLabel.mas_right).offset(20);
        make.bottom.equalTo(self.monthLabel);
        make.top.equalTo(self.dayLabel);
        make.width.mas_equalTo(1.0);
    }];
    
    //问候语
    [self.greetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(15);
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(13);
        make.bottom.equalTo(self).offset(-13);
    }];
    
    //登录按钮
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.greetLabel); //跟问候语在同一水平线
        make.width.height.mas_equalTo(50);
    }];
}

//控制左上角日期显示的方法
- (void)settingDate:(NSString *)dateString{
    //设置转换格式 可以将网络请求返回的日期数据转换为年月日的相关数据
    NSDateFormatter *temp = [[NSDateFormatter alloc]init];
    temp.dateFormat = @"yyyyMMdd";
    //按yyyy（前四位数表示年份）MM（这两位数表示月份）dd（最后两位数表示日期）的格式将网络请求返回的date字符串转换为nsdate类型的数据
    NSDate *date = [temp dateFromString:dateString];
    
    //处理日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"dd";
    //按dateformatter的格式（dd，即最后两位代表的日期）从上面的nsdate类型的date数据里拿到日期字符串
    NSString *day = [dateFormatter stringFromDate:date];
    //赋值并设置相关参数
    self.dayLabel.text = day;
    self.dayLabel.font = [UIFont boldSystemFontOfSize:30];
    self.dayLabel.textColor = [UIColor labelColor];
    
    //处理月份
    dateFormatter.dateFormat = @"MMMM"; //MMMM：月份全称（二月/February）
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"]; //将语言区域设置为中文
    //按MMMM（月份全称）的格式拿到月份信息
    NSString *month = [dateFormatter stringFromDate:date];
    //赋值并设置相关参数
    self.monthLabel.text = month;
    self.monthLabel.font = [UIFont systemFontOfSize:18];
    self.monthLabel.textColor = [UIColor labelColor];
}

//设置问候语信息
-(void)settingGreeting:(UILabel *)greetLabel{
    //获取当前绝对时间（nsdate类型）
    NSDate *currentDate = [NSDate date];
    //获取当前用户的日历信息
    NSCalendar *calender = [NSCalendar currentCalendar];
    //按上面获取到的日历信息从绝对时间currentDate里取出所需要的“小时”数值
    NSInteger hour = [calender component:NSCalendarUnitHour fromDate:currentDate];
    //设置问候语及相关参数
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
    greetLabel.textColor = [UIColor labelColor];
}

//触发点击事件login后自动执行block回调代码块（在viewcontroller里实现），实现点击后跳转的效果
-(void)login{
    if(self.loginBlock){
        self.loginBlock();
    }
}

@end
