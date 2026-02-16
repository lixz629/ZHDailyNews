//
//  AppDelegate.m
//  ZhihuDailyNews
//
//  Created by lxz on 2026/2/3.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.初始化窗口并设置大小为整个屏幕
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口背景颜色为白色
    self.window.backgroundColor = [UIColor whiteColor];
    //初始化并设置根视图控制器
    ViewController *vc = [[ViewController alloc]init];
    self.window.rootViewController = vc;
    //使当前窗口成为主窗口并可视
    [self.window makeKeyAndVisible];
    
    return YES;
}





@end
