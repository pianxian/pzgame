//
//  PZAlertManager.h
//  PuzGame
//
//  Created by hww on 2018/7/20.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZAlertManager : NSObject
+(instancetype)shareManager;
-(void)alertWithAlertControllerStyle:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle inControl:(UIViewController *)controller action:(void (^)(void))handler;
-(void)alertWithStyle:(UIAlertControllerStyle)style actions:(nullable NSArray *)actions title:(NSString *)title message:(NSString *)message inContrl:(UIViewController *)controller action:(void(^)(NSInteger tag))handler;
@end
