//
//  UIColor+SMColor.h
//  SMJG
//
//  Created by HWW on 2017/8/29.
//  Copyright © 2017年 HWW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SMColor)
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString
                            andAlpha:(CGFloat)alpha;


// 16进制颜色
+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
@end
