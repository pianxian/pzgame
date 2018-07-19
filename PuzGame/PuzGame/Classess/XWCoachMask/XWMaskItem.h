//
//  XWMaskItem.h
//  XWSuperWidgetDemo
//
//  Created by 王剑石 on 17/1/6.
//  Copyright © 2017年 王剑石. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XWMaskShape) {
    SHAPE_DEFAULT,
    SHAPE_CIRCLE,
    SHAPE_SQUARE,
    SHAPE_CUSTOME,
};

typedef NS_ENUM(NSInteger, XWTipPosition) {
    TIP_POSITION_BOTTOM,
    TIP_POSITION_LEFT,
    TIP_POSITION_TOP,
    TIP_POSITION_RIGHT,
    TIP_POSITION_RIGHT_BOTTOM
};

@interface XWMaskItem : NSObject

@property (nonatomic, assign) XWMaskShape maskShap;

@property (nonatomic, assign) CGRect maskRect;

@property (nonatomic, assign) XWTipPosition labPosition;

@property (nonatomic, strong) NSString *tipTitle;

@property (nonatomic, assign) BOOL showArrowImage;

@property (nonatomic, strong) NSString *arrowImage;

@property (nonatomic, strong) UIBezierPath *maskPath;


-(instancetype)initWithMaskItem:(void (^) (XWMaskItem *mask)) maskBlock;

@end
