//
//  PZAlertManager.m
//  PuzGame
//
//  Created by hww on 2018/7/20.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZAlertManager.h"

@implementation PZAlertManager
static PZAlertManager *instance = nil;
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PZAlertManager alloc] init];
    });
    return instance;
}
-(void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle inControl:(UIViewController *)controller action:(void (^)(void))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [alert addAction:actionAction];
    [controller presentViewController:alert animated:YES completion:nil];
}
@end
