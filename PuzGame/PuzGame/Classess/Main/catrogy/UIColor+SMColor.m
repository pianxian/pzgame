//
//  UIColor+SMColor.m
//  SMJG
//
//  Created by HWW on 2017/8/29.
//  Copyright © 2017年 HWW. All rights reserved.
//

#import "UIColor+SMColor.h"

@implementation UIColor (SMColor)
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString
                            andAlpha:(CGFloat)alpha{
    if ([hexColorString length] <6){//长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString=[hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]){//检查开头是0x
        tempString = [tempString substringFromIndex:2];
    }else if ([tempString hasPrefix:@"#"]){//检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] !=6){
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range;
    range.location =0;
    range.length =2;
    NSString *rString = [tempString substringWithRange:range];
    range.location =2;
    NSString *gString = [tempString substringWithRange:range];
    range.location =4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString]scanHexInt:&r];
    [[NSScanner scannerWithString:gString]scanHexInt:&g];
    [[NSScanner scannerWithString:bString]scanHexInt:&b];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        return [UIColor colorWithDisplayP3Red:((float) r /255.0) green:((float) g /255.0) blue:((float) b /255.0) alpha:alpha];
    }else{
        return  [UIColor colorWithRed:((float) r /255.0)
                                green:((float) g /255.0)
                                 blue:((float) b /255.0)
                                alpha:alpha];
    }
    //    //值为10.0
    //    [[UIDevice currentDevice] systemVersion]
    //    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 9, .minorVersion = 1, .patchVersion = 0}]) {
    //        NSLog(@"Hello from > iOS 9.1");
    //    }
    //    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,3,0}]) {
    //        NSLog(@"Hello from > iOS 9.3");
    //    }
    //    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) { // do stuff for iOS 9 and newer} else {
    //        // do stuff for older versions than iOS 9
    //    }
    //
    
}


+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        return [UIColor colorWithDisplayP3Red:((float)((hexValue & 0xFF0000) >> 16))/255.0
                                        green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                         blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
        
    }else{
        return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                               green:((float)((hexValue & 0xFF00) >> 8))/255.0
                                blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
    }
    
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    
    return [self colorWithHex:hexValue alpha:1.0];
}
@end
