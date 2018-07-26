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
-(void)alertWithStyle:(UIAlertControllerStyle)style actions:(nullable NSArray *)actions title:(NSString *)title message:(NSString *)message inContrl:(UIViewController *)controller action:(void(^)(NSInteger tag))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    [actions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *actionAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler(idx);
        }];
        [alert addAction:actionAction];
    }];

    UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
//    [alert addAction:actionAction];
    if (style == UIAlertControllerStyleActionSheet) {
        [alert addAction:canelAction];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}
-(void)alertWithAlertControllerStyle:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle inControl:(UIViewController *)controller action:(void (^)(void))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *actionAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionAction];
    if (style == UIAlertControllerStyleActionSheet) {
        [alert addAction:canelAction];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}
@end
