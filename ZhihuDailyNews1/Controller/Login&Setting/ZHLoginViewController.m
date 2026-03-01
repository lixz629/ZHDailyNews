//
//  ZHLoginViewController.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/20.
//

#import "ZHLoginViewController.h"
#import "Masonry.h" //布局
#import "SettingViewController.h" //设置vc
#import "ZHWebViewController.h" //协议vc

@interface ZHLoginViewController ()

@end

@implementation ZHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化并布局UI
    [self setupUI];
    //已经保存的模式状态（夜间or日间）
    BOOL savedDarkMode = [[NSUserDefaults standardUserDefaults]boolForKey:@"UserAppDarkMode"];
    //设置模式状态
    self.modeButton.selected = savedDarkMode;
    //根据当前模式状态设置系统状态（深色or浅色）
    self.view.window.overrideUserInterfaceStyle = savedDarkMode ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)setupUI{
    self.modeButton = [[UIButton alloc]init];
    self.settingButton = [[UIButton alloc]init];
    self.agreementText = [[UITextView alloc]init];
    self.mainView = [[ZHLoginMainView alloc]init];
    [self.view addSubview:self.modeButton];
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.agreementText];
    
    [self makeConstraints];
    [self settingData];;
    
    //添加点击事件
    [self.modeButton addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingButton addTarget:self action:@selector(clickSetting:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)makeConstraints{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).multipliedBy(0.8);
        make.left.right.equalTo(self.view);
    }];
    [self.modeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.centerX.equalTo(self.view).offset(-70);
        make.width.height.mas_equalTo(100);
    }];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.modeButton);
        make.centerX.equalTo(self.view).offset(70);
        make.width.height.mas_equalTo(100);
    }];
    [self.modeButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modeButton.mas_top);
        make.centerX.equalTo(self.modeButton);
        make.width.height.mas_equalTo(40);
    }];
    [self.modeButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modeButton.imageView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.modeButton);
    }];
    [self.settingButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingButton.mas_top);
        make.centerX.equalTo(self.settingButton);
        make.width.height.mas_equalTo(40);
    }];
    [self.settingButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.settingButton.imageView.mas_bottom).offset(-20);
        make.centerX.equalTo(self.settingButton);
    }];
    [self.agreementText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.stateButton.mas_right).offset(8);
        make.centerY.equalTo(self.mainView.stateButton);
        make.right.equalTo(self.view).offset(-20);
    }];
}

//设置相关数据
-(void)settingData{
    //设置夜间模式图片
    [self.modeButton setImage:[UIImage imageNamed:@"nightMode"] forState:UIControlStateNormal];
    [self.modeButton setTitle:@"夜间模式" forState:UIControlStateNormal];
    
    //设置日间模式图片
    [self.modeButton setImage:[UIImage imageNamed:@"sunMode"] forState:UIControlStateSelected];
    [self.modeButton setTitle:@"日间模式" forState:UIControlStateSelected];
    
    //设置字体大小
    self.modeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //图片颜色
    self.modeButton.tintColor = [UIColor labelColor];
    //字体颜色
    [self.modeButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    [self.modeButton setTitleColor:[UIColor labelColor] forState:UIControlStateSelected];
    
    //按原比例缩放图片
    self.modeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //裁剪到边缘
    self.modeButton.imageView.clipsToBounds = YES;
    
    //‘设置’按钮的图片
    [self.settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [self.settingButton setTitle:@"设置" forState:UIControlStateNormal];
    
    //设置字体颜色和大小
    [self.settingButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    self.settingButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //设置图片的相关属性
    self.settingButton.imageView.clipsToBounds = YES;
    self.settingButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.settingButton.tintColor = [UIColor labelColor];
    
    //文本字符串
    NSString *fullText = @"我同意《知乎协议》和《个人信息保护指引》";
    //用上面的文本字符串初始化一个可变富文本字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:fullText];
    //字体大小
    UIFont *textFont = [UIFont systemFontOfSize:15];
    //设置整个富文本的字体颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor secondaryLabelColor] range:NSMakeRange(0, fullText.length)];
    //为知乎协议和个人信息保护指引的部分设置url链接属性
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"protocol://"] range:[fullText rangeOfString:@"《知乎协议》"]];
    [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"privacy://"] range:[fullText rangeOfString:@"《个人信息保护指引》"]];
    //设置字体大小
    [attributedString addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, fullText.length)];
    
    //不可编辑
    self.agreementText.editable = NO;
    //不可滚动
    self.agreementText.scrollEnabled = NO;
    //设置代理
    self.agreementText.delegate = self;
    //将上面已经写好的富文本赋值给textview
    self.agreementText.attributedText = attributedString;
    //为具有链接属性的部分设置特有属性（蓝色字体）
    self.agreementText.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor systemBlueColor]};
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    //协议vc
    ZHWebViewController *webVC = [[ZHWebViewController alloc]init];
    
    //根据点击链接的标签不同设置不同的协议网址及相应的导航栏标题
    if([URL.scheme isEqualToString:@"protocol"]){
        webVC.navTitle = @"知乎协议 - 知乎";
        webVC.urlString = @"https://www.zhihu.com/term/zhihu-terms";
    }else if ([URL.scheme isEqualToString:@"privacy"]){
        webVC.navTitle = @"个人信息保护指引 - 知乎";
        webVC.urlString = @"https://www.zhihu.com/term/privacy";
    }
    
    //跳转
    if(webVC.urlString){
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }
    
    return NO;
}

#pragma mark - 点击事件
//模式切换
-(void)changeMode:(UIButton *)sender{
    //点击后状态反转
    sender.selected = !sender.selected;
    //记录点击后的按钮状态
    BOOL isDarkMode = sender.selected;
    //将当前的按钮状态以UserAppDarkMode的标签保存下来
    [[NSUserDefaults standardUserDefaults]setBool:isDarkMode forKey:@"UserAppDarkMode"];
    //根据按钮状态设置整个应用界面的颜色状态
    UIWindow *window = self.view.window;
    if(sender.selected){
        window.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }else{
        window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}

//设置
-(void)clickSetting:(UIButton *)sender{
    //点击后跳转到设置界面
    SettingViewController *settingVc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVc animated:YES];
}


@end
