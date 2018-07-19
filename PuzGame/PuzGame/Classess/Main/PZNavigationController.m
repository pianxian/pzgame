
//
//  PZNavigationController.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZNavigationController.h"
#import <SDTheme.h>
#define IOS_VERSION            [[[UIDevice currentDevice] systemVersion] floatValue]

#define SMCOLOR(r,g,b,a) (IOS_VERSION >=10.0f ? [UIColor colorWithDisplayP3Red:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)] : [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

@interface PZNavigationController ()

@end

@implementation PZNavigationController

- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:SMCOLOR(96, 96, 96,1),NSFontAttributeName:[UIFont systemFontOfSize:17]};
//    [self.navigationItem.leftBarButtonItem theme_setTitleTextAttributes:@{SDThemeForegroundColorAttributeName:@"block_bg",NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} forState:UIControlStateNormal];
//      [self.navigationItem.leftBarButtonItem theme_setTitleTextAttributes:@{SDThemeForegroundColorAttributeName:@"block_bg",NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} forState:UIControlStateHighlighted];
//    self.navigationItem.leftBarButtonItem
//    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SMCOLOR(96, 96, 96,1),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} forState:UIControlStateNormal];
//    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SMCOLOR(96, 96, 96,1),NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} forState:UIControlStateHighlighted];
//    [self.navigationBar setTintColor:SMCOLOR(96, 96, 96,1)];
    self.navigationBar.theme_barTintColor = @"block_bg";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc]init];
    //    returnButtonItem.title = @"返回";
    //    viewController.navigationItem.backBarButtonItem = returnButtonItem;
    
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        
    }
    
    [super pushViewController:viewController animated:animated];
}
+ (void)initialize {
    [PZNavigationController setupNavTheme];
}
// 设置导航栏的主题
+(void)setupNavTheme{
    // 设置导航样式
    
    UINavigationBar *navBar = [UINavigationBar appearance
                               ];
    
    //    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.377 green:0.858 blue:1.000 alpha:1.000]];
    // 1.设置导航条的背景
    
    // 高度不会拉伸，但是宽度会拉伸
    //  [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    // 2.设置栏的字体
//    NSMutableDictionary *att = [NSMutableDictionary dictionary];
//    att[SDThemeForegroundColorAttributeName] = @"text_h1";
//    att[NSFontAttributeName] = [UIFont systemFontOfSize:18];
//    
//    [navBar setTitleTextAttributes:att];
    
    // 设置状态栏的样式
    // xcode5以上，创建的项目，默认的话，这个状态栏的样式由控制器决定
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

@end
