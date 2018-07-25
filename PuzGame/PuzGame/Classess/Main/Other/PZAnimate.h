//
//  PZAnimate.h
//  PuzGame
//
//  Created by hww on 2018/7/24.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PZAnimate;

typedef PZAnimate *(^show)(void);
typedef PZAnimate *(^hide)(void);
@interface PZAnimate : NSObject

@property (nonatomic,strong,readonly) show showAction;
@property (nonatomic,strong,readonly) hide hideAction;
@property (nonatomic,assign) BOOL hideWhenTap;
@property (nonatomic,strong) UIView *animationView;
+(void)animateAcion:(void(^)(PZAnimate *base))block animationView:(UIView *)animateView;

@end
