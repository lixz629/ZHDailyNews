//
//  ZHNewsDetailViewController.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/12.
//

#import "ZHNewsDetailViewController.h"
#import "WebKit/WebKit.h"
#import "AFNetworking.h"
#import "Ono.h"
#import "ZHNewsDetailHeaderView.h"
#import "ZHNewsBottomView.h"
#import "Masonry.h"
#import "ZHNewsCommentViewController.h"
#import "MBProgressHUD.h"

@interface ZHNewsDetailViewController ()<ZHNewsBottomViewDelegate,WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)ZHNewsDetailHeaderView *headerView;
@property(nonatomic,strong)ZHNewsBottomView *bottomView;

@end

@implementation ZHNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self webView];
    [self.view addSubview:self.webView];
    [self loadDetailData];
    [self headerView];
    [self bottomView];
    [self loadExtraData];
    [self.headerView.linkButton addTarget:self action:@selector(clickLick) forControlEvents:UIControlEventTouchUpInside];
    [self.webView.scrollView addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    [self makeBottomViewConstraints];
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

-(void)loadDetailData{
    NSString *url = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/4/news/%@",self.newsID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.shareUrl = responseObject[@"share_url"];
        // 1. 提取数据
        NSString *body = responseObject[@"body"];
        NSArray *cssArray = responseObject[@"css"];
        
        NSError *error;
        ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithString:body encoding:NSUTF8StringEncoding error:&error];
        ONOXMLElement *authorName = [doc firstChildWithCSS:@".author"];
        NSString *name = authorName.stringValue;
        NSString *cleanName = [name stringByReplacingOccurrencesOfString:@"，" withString:@""];
        NSString *realName = [NSString stringWithFormat:@"作者 / %@",cleanName];
        
            
        // 2. 开始拼接 HTML
        NSMutableString *htmlString = [NSMutableString string];
        [htmlString appendString:@"<html><head>"];
            
        // 注入 Viewport 保证缩放正常
        [htmlString appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, user-scalable=no\">"];
            
        // --- 这里开始插入 CSS 样式 ---
        [htmlString appendString:@"<style>"];
            
        // 整体页面设置：字号、边距、行高
        [htmlString appendString:@"body { margin: 0; padding: 15px; font-size: 20px; line-height: 1.6; color: #444; }"];
            
        // 图片设置：控制宽度为 100% 并居中
        [htmlString appendString:@"img { width: 100% !important; height: auto !important; display: block; margin: 0px auto; border-radius: 8px; }"];
            
        // 补充：确保内容不会紧贴边缘
        [htmlString appendString:@".content-inner { padding: 0 !important; }"];
        
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
        self.bottomView.commentLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"comments"]];
        self.bottomView.likeLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"popularity"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}

- (WKWebView *)webView{
    if(_webView == nil){
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //记录y方向偏移量
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //向上滑动(看正文时)
    if(offsetY < 0){
        CGRect frame = self.headerView.frame;
        frame.origin.y = offsetY;
        frame.size.height = self.view.frame.size.height * 0.4 - offsetY;
        self.headerView.frame = frame;
    }
    //向下滑动
    else{
        CGRect frame = self.headerView.frame;
        frame.origin.y = 0;
        frame.size.height = self.view.frame.size.height * 0.4;
        self.headerView.frame = frame;
    }
}

- (ZHNewsBottomView *)bottomView{
    if(_bottomView == nil){
        _bottomView = [[ZHNewsBottomView alloc]init];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    return _bottomView;
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
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)clickReturn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickComment{
    ZHNewsCommentViewController *commentVc = [[ZHNewsCommentViewController alloc]init];
    [self.navigationController pushViewController:commentVc animated:YES];
}

- (void)clickLike{
    NSInteger currentLikes = [self.bottomView.likeLabel.text integerValue];
    if(self.bottomView.likeButton.selected){
        self.bottomView.likeLabel.text = [NSString stringWithFormat:@"%zd",currentLikes + 1];
        [self likeShowHudWithText:@"已点赞" isSuccess:self.bottomView.likeButton.selected];
    }else{
        self.bottomView.likeLabel.text = [NSString stringWithFormat:@"%zd",currentLikes - 1];
        [self likeShowHudWithText:@"已取消点赞" isSuccess:self.bottomView.likeButton.selected];
    }
}

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
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = url.absoluteString;
    if(navigationAction.navigationType == WKNavigationTypeLinkActivated && [urlString containsString:@"zhihu.com"]){
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

-(void)clickLick{
    if(self.shareUrl){
        NSURL *url = [NSURL URLWithString:self.shareUrl];
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
    }
}

-(void)likeShowHudWithText:(NSString *)text isSuccess:(bool)isSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(isSuccess){
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [UIImage imageNamed:@"success"];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[imgView.widthAnchor constraintEqualToConstant:40],[imgView.heightAnchor constraintEqualToConstant:40]]];
        hud.customView = imgView;
    }else{
        hud.mode = MBProgressHUDModeText;
    }
    hud.label.text = text;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    hud.label.textColor = [UIColor whiteColor];
    [hud hideAnimated:YES afterDelay:1.0];
}

-(void)clickCollect{
    if(self.bottomView.collectButton.selected){
        [self collectShowHudWithText:@"已收藏"];
    }else{
        [self collectShowHudWithText:@"已取消收藏"];
    }
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

@end
