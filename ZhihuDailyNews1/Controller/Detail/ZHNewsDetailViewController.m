//
//  ZHNewsDetailViewController.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import "ZHNewsDetailViewController.h"
#import "WebKit/WebKit.h"
#import "AFNetworking.h" //网络请求
#import "Ono.h" //处理html数据得到需要的内容
#import "ZHNewsDetailHeaderView.h" //顶部大图
#import "ZHNewsBottomView.h" //底部工具栏
#import "Masonry.h" //布局
#import "ZHNewsCommentViewController.h" //评论vc
#import "MBProgressHUD.h" //点赞/收藏提示框
#import "ZHShareView.h" //点击分享按钮弹出的窗口

@interface ZHNewsDetailViewController ()<ZHNewsBottomViewDelegate,WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView; //网页显示view
@property(nonatomic,strong)ZHNewsDetailHeaderView *headerView; //顶部大图
@property(nonatomic,strong)ZHNewsBottomView *bottomView; //底部工具栏

@end

@implementation ZHNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self webView];
    [self.view addSubview:self.webView];
    //获取数据
    [self loadDetailData];
    [self headerView];
    [self bottomView];
    //获取额外数据（评论数，点赞数）
    [self loadExtraData];
    //添加点击事件
    [self.headerView.linkButton addTarget:self action:@selector(clickLick) forControlEvents:UIControlEventTouchUpInside];
    //将顶部大图添加到scrollview上，便于实现回弹效果
    [self.webView.scrollView addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    
    [self makeBottomViewConstraints];
    //设置代理
    self.webView.scrollView.delegate = self;
    self.bottomView.delegate = self;
    self.webView.navigationDelegate = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 网络请求
-(void)loadDetailData{
    //根据新闻id获取详情页url
    NSString *url = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/%@",self.newsID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.shareUrl = responseObject[@"share_url"];
        // 1. 提取数据
        NSString *body = responseObject[@"body"];
        NSArray *cssArray = responseObject[@"css"];
        
        //获取html数据中的作者名称信息
        NSError *error;
        ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithString:body encoding:NSUTF8StringEncoding error:&error];
        ONOXMLElement *authorName = [doc firstChildWithCSS:@".author"];
        
        //将作者名称以字符串的形式赋值给name
        NSString *name = authorName.stringValue;
        //格式化处理得到知乎日报需要展示的格式
        NSString *cleanName = [name stringByReplacingOccurrencesOfString:@"，" withString:@""];
        NSString *realName = [NSString stringWithFormat:@"作者 / %@",cleanName];
        
        // 2. 开始拼接 HTML
        NSMutableString *htmlString = [NSMutableString string];
        [htmlString appendString:@"<html><head>"];
            
        // 注入 Viewport 保证缩放正常
        [htmlString appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no\">"];
        
        //适配夜间模式
        NSString *bgColor = @"#ffffff"; //纯白色
        NSString *textColor = @"#444"; //深灰色

        if (@available(iOS 13.0, *)) {
            // 检查当前是否为深色模式
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                bgColor = @"#1a1a1a"; // 深灰色背景
                textColor = @"#d3d3d3"; // 浅灰色文字
            }
        }
            
        // --- 这里开始插入 CSS 样式 ---
        [htmlString appendString:@"<style>"];
            
        // 整体页面设置：字号、边距、行高
        [htmlString appendFormat:@"body { margin: 0; padding: 15px; font-size: 20px; line-height: 1.6; background-color: %@; color: %@; }", bgColor, textColor];
            
        // 图片设置：控制宽度为 100% 并居中
        [htmlString appendString:@"img { width: 100% !important; height: auto !important; display: block; margin: 0px auto; border-radius: 8px; opacity: 0.8;}"];
            
        // 补充：确保内容不会紧贴边缘
        [htmlString appendFormat:@".content-inner { padding: 0 !important; background-color: %@; }", bgColor];
        
        //隐藏自带的作者信息栏
        [htmlString appendString:@".meta { display: none !important; }"];
        
        [htmlString appendString:@"</style>"];
        // --- CSS 插入结束 ---
        
        // 拼接知乎原始的 CSS 链接
        for (NSString *cssUrl in cssArray) {
            [htmlString appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">", cssUrl];
        }
            
        [htmlString appendString:@"</head><body>"];
        [htmlString appendFormat:@"<div style=\"height: %.0fpx; overflow: hidden;\"></div>",self.view.frame.size.height * 0.4];
        [htmlString appendString:body]; // 放入正文
        [htmlString appendString:@"</body></html>"];
            
        // 3. 在主线程加载到 WebView
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:htmlString baseURL:nil];
            //赋值
            [self.headerView settingData:responseObject];
            [self.headerView settingAuthorName:realName];
        });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}

-(void)loadExtraData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *extraUrl = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/story-extra/%@",self.newsID];
    [manager GET:extraUrl parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //赋值
        self.bottomView.commentLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"comments"]];
        self.bottomView.likeLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"popularity"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}

#pragma mark - 懒加载
- (WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor systemBackgroundColor];
        _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 85, 0);
    }
    return _webView;
}

- (ZHNewsDetailHeaderView *)headerView{
    if(_headerView == nil){
        _headerView = [[ZHNewsDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.4)];
        [_headerView refreshLayoutFroce];
    }
    return _headerView;
}

- (ZHNewsBottomView *)bottomView{
    if(_bottomView == nil){
        _bottomView = [[ZHNewsBottomView alloc]init];
        _bottomView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }
    return _bottomView;
}

#pragma mark - 点击事件
- (void)clickReturn{
    //返回上一个页面（出栈）
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickComment{
    //跳转到评论界面
    ZHNewsCommentViewController *commentVc = [[ZHNewsCommentViewController alloc]init];
    [self.navigationController pushViewController:commentVc animated:YES];
}

- (void)clickLike{
    //获取当前赞数
    NSInteger currentLikes = [self.bottomView.likeLabel.text integerValue];
    if(self.bottomView.likeButton.selected){
        //点赞后赞数+1
        self.bottomView.likeLabel.text = [NSString stringWithFormat:@"%zd",currentLikes + 1];
        //弹出已点赞的弹窗
        [self likeShowHudWithText:@"已点赞" isSuccess:self.bottomView.likeButton.selected];
    }else{
        self.bottomView.likeLabel.text = [NSString stringWithFormat:@"%zd",currentLikes - 1];
        [self likeShowHudWithText:@"已取消点赞" isSuccess:self.bottomView.likeButton.selected];
    }
}

//作者名右边的点击查看知乎原文按钮的点击事件
-(void)clickLick{
    if(self.shareUrl){
        //跳转到知乎上对应的新闻原文（Safari浏览器）
        NSURL *url = [NSURL URLWithString:self.shareUrl];
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
}

-(void)clickCollect{
    if(self.bottomView.collectButton.selected){
        [self collectShowHudWithText:@"已收藏"];
    }else{
        [self collectShowHudWithText:@"已取消收藏"];
    }
}

- (void)clickShare{
    [ZHShareView showWithcompletion:^(NSInteger index) {
        
    }];
}

-(void)likeShowHudWithText:(NSString *)text isSuccess:(bool)isSuccess{
    //先隐藏之前存在的hud
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    //添加新hud
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(isSuccess){
        //自定义view
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [UIImage imageNamed:@"success"];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        //禁用自动调整大小
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        //将图片的宽高定死为40
        [NSLayoutConstraint activateConstraints:@[[imgView.widthAnchor constraintEqualToConstant:40],[imgView.heightAnchor constraintEqualToConstant:40]]];
        hud.customView = imgView;
    }else{
        //只显示纯文字
        hud.mode = MBProgressHUDModeText;
    }
    hud.label.text = text;
    //设置弹窗效果为纯色模式
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置背景颜色
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    //设置文字颜色
    hud.label.textColor = [UIColor whiteColor];
    //1.0s后自动隐藏
    [hud hideAnimated:YES afterDelay:1.0];
}

-(void)collectShowHudWithText:(NSString *)text{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.label.textColor = [UIColor whiteColor];
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //记录y方向偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //向上滑动
    if(offsetY < 0){
        CGRect frame = self.headerView.frame;
        //固定住顶部
        frame.origin.y = offsetY;
        //根据下拉量改变图片大小
        frame.size.height = self.view.frame.size.height * 0.4 - offsetY;
        self.headerView.frame = frame;
    }
    //停止向上滑动时
    else{
        CGRect frame = self.headerView.frame;
        //恢复到初始状态
        frame.origin.y = 0;
        frame.size.height = self.view.frame.size.height * 0.4;
        self.headerView.frame = frame;
    }
}

-(void)makeBottomViewConstraints{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(75);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
}

//为底部查看知乎讨论的蓝色按钮设置格式
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
        // 定义 JS 字符串，通过 CSS 类名或选择器精准定位那个链接
        // 假设该链接的 class 包含 'view-discussion' 或它是特定的 a 标签
        NSString *js =
        @"var container = document.querySelector('.view-more');" // 找到外层容器
        "if (container) {"
        "   var link = container.querySelector('a');"           // 找到容器里的链接
        "   if (link) {"
        "       link.style.display = 'block';"                 // 撑开点击区域
        "       link.style.backgroundColor = '#0084FF';"       // 知乎蓝
        "       link.style.color = '#FFFFFF';"                // 白色文字
        "       link.style.textAlign = 'center';"             // 文字居 center
        "       link.style.padding = '12px 0';"               // 按钮高度
        "       link.style.margin = '20px 15px';"             // 左右留出间距
        "       link.style.borderRadius = '25px';"            // 圆角
        "       link.style.textDecoration = 'none';"          // 去掉下划线
        "       link.style.fontSize = '25px';"                // 字号
        "       link.style.fontWeight = '500';"               // 稍微加粗
        "   }"
        "}";
    
        [webView evaluateJavaScript:js completionHandler:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(WK_SWIFT_UI_ACTOR void (^)(WKNavigationActionPolicy))decisionHandler{
    //获取此次跳转信息中的url
    NSURL *url = navigationAction.request.URL;
    //将url中的信息提取为字符串
    NSString *urlString = url.absoluteString;
    //如果此次跳转是通过点击链接跳转且跳转信息中的url字符串包含zhihu.com执行后面的代码
    if(navigationAction.navigationType == WKNavigationTypeLinkActivated && [urlString containsString:@"zhihu.com"]){
        //在外部打开url
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        //禁止webview在当前窗口加载新页面
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
