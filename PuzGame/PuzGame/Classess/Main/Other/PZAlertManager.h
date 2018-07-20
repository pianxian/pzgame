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
-(void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle inControl:(UIViewController *)controller action:(void (^)(void))handler;
@end
