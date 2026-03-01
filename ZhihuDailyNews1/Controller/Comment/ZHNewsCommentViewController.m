//
//  ZHNewsCommentViewController.m
//  ZhihuDailyNews1
//
//  Created by lxz on 2026/2/15.
//

#import "ZHNewsCommentViewController.h"

@interface ZHNewsCommentViewController ()

@end

@implementation ZHNewsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self.navigationController setNavigationBarHidden:NO];
}

@end
