//
//  AppDelegate.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "AppDelegate.h"
#import "PZGameViewController.h"
#import "PZLanchViewController.h"
#import "PZNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
void UncaughExceptionHandler(NSException *exception){
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSLog(@">>>>>>>>>>>>> 捕捉崩溃信息 如下<<<<<<<<<<<<<");
    NSLog(@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr);
    NSLog(@"=================end====================");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(UncaughExceptionHandler);
//    [self configBugly];
    [MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    [[SDThemeManager sharedInstance] setupThemeNameArray:@[@"PZBlack", @"PZWhite",@"PZGreen"]];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"backImgTpye"]) {
    [[SDThemeManager sharedInstance] changeTheme:[[NSUserDefaults standardUserDefaults] stringForKey:@"backImgTpye"]];
    }else{
       [[SDThemeManager sharedInstance] changeTheme:@"PZWhite"];
    }

    [Bugly startWithAppId:PZBuglyKey];

    [[UIApplication sharedApplication] theme_setStatusBarColor:@"status_bar_default" animated:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    PZLanchViewController *lanchView = [[PZLanchViewController alloc] init];
    
    lanchView.animationfinish = ^{
        PZGameViewController *gameView = [[PZGameViewController alloc] init];
        PZNavigationController *navgation = [[PZNavigationController alloc] initWithRootViewController:gameView];
        self.window.rootViewController = navgation;
    };
    self.window.rootViewController = lanchView;
    [self.window makeKeyAndVisible];
    return YES;
}
//-(void)configBugly{
//    //初始化 Bugly 异常上报
//    BuglyConfig *config = [[BuglyConfig alloc] init];
//    config.delegate = self;
//    config.debugMode = YES;
//    config.reportLogLevel = BuglyLogLevelInfo;
//    [Bugly startWithAppId:@"900001055"
//#if DEBUG
//        developmentDevice:YES
//#endif
//                   config:config];
//
//    //捕获 JSPatch 异常并上报
//    [JPEngine handleException:^(NSString *msg) {
//        NSException *jspatchException = [NSException exceptionWithName:@"Hotfix Exception" reason:msg userInfo:nil];
//        [Bugly reportException:jspatchException];
//    }];
//    //检测补丁策略
//    [[BuglyMender sharedMender] checkRemoteConfigWithEventHandler:^(BuglyHotfixEvent event, NSDictionary *patchInfo) {
//        //有新补丁或本地补丁状态正常
//        if (event == BuglyHotfixEventPatchValid || event == BuglyHotfixEventNewPatch) {
//            //获取本地补丁路径
//            NSString *patchDirectory = [[BuglyMender sharedMender] patchDirectory];
//            if (patchDirectory) {
//                //指定执行的 js 脚本文件名
//                NSString *patchFileName = @"main.js";
//                NSString *patchFile = [patchDirectory stringByAppendingPathComponent:patchFileName];
//                //执行补丁加载并上报激活状态
//                if ([[NSFileManager defaultManager] fileExistsAtPath:patchFile] &&
//                    [JPEngine evaluateScriptWithPath:patchFile] != nil) {
//                    NSLog(@"evaluateScript success");
//                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveSucess];
//                }else {
//                    NSLog(@"evaluateScript failed");
//                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveFail];
//                }
//            }
//        }
//    }];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//#ifdef NSFoundationVersionNumber_iOS_9_0
//
//
//#endif

@end
