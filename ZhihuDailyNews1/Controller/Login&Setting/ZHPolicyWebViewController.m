//
//  ZHWebViewController.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/22.
//

#import "ZHPolicyWebViewController.h"
#import "WKWebView+AFNetworking.h"

@interface ZHWebViewController ()

@end

@implementation ZHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景颜色
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    //设置顶部标题
    self.title = self.navTitle;
    //加载相应的网页内容
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:webView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
