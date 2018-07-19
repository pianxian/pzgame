//
//  XWCoachMask.h
//  XWSuperWidgetDemo
//
//  Created by 王剑石 on 17/1/6.
//  Copyright © 2017年 王剑石. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWMaskItem.h"

@protocol XWCoachMaskDelegate;

@interface XWCoachMask : UIView

@property (nonatomic, weak) id<XWCoachMaskDelegate> delegate;

//添加一个指引项
-(XWCoachMask *(^) (XWMaskItem *))add;

//以一组指引项初始化
-(instancetype)initWithFrame:(CGRect)frame coachMasks:(NSArray<XWMaskItem *> *)masks;

//显示指引页
-(void)showCoachMaskInview:(UIView *)superView;

@end

@protocol XWCoachMaskDelegate <NSObject>

//即将显示下一个指引项
- (void)xwMaskView:(XWCoachMask *)maskView willSwitchToIndex:(NSUInteger)index;

//显示下一个指引项完成
- (void)xwMaskView:(XWCoachMask *)maskView didSwitchToIndex:(NSUInteger)index;


@end
