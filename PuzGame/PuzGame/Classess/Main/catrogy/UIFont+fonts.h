//
//  UIFont+fonts.h
//  XJG
//
//  Created by HWW on 2016/11/25.
//  Copyright © 2016年 HWW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (fonts)
/**
 *  HYQiHei-BEJF font (added by plist).
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HYQiHeiWithFontSize:(CGFloat)size;

#pragma mark - System font.

/**
 *  AppleSDGothicNeo-Thin font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)AppleSDGothicNeoThinWithFontSize:(CGFloat)size;

/**
 *  Avenir font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)AvenirWithFontSize:(CGFloat)size;

/**
 *  Avenir-Light font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)AvenirLightWithFontSize:(CGFloat)size;

/**
 *  Heiti SC font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HeitiSCWithFontSize:(CGFloat)size;

/**
 *  HelveticaNeue font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HelveticaNeueFontSize:(CGFloat)size;

/**
 *  HelveticaNeue-Bold font.
 *
 *  @param size Font's size.
 *
 *  @return Font.
 */
+ (UIFont *)HelveticaNeueBoldFontSize:(CGFloat)size;
@end
