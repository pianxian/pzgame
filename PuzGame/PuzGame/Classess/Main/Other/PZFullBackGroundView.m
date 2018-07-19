//
//  PZFullBackGroundView.m
//  PuzGame
//
//  Created by hww on 2018/7/19.
//  Copyright © 2018年 hww. All rights reserved.
//

#define iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.height == 1136)
#import "PZFullBackGroundView.h"
#import "UIView+PZImage.h"
@implementation PZFullBackGroundView
{
    NSString *_bgImgName;
}
- (void)setBackgroundImgWithName:(NSString *)name{
    _bgImgName = name;
    [self setNeedsLayout];
}
-(void)drawRect:(CGRect)rect{
    if (_bgImgName) {
        UIImage *bgImg = [UIImage imageNamed:_bgImgName];
        CGFloat width = 640;
        CGFloat height = iPhone5 ? 1136:960;
        CGRect cutRect = CGRectMake((bgImg.size.width - width)*0.5, (bgImg.size.height - height) *0.5, width, height);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(bgImg.CGImage, cutRect);
        bgImg = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        [bgImg drawInRect:rect];
    }
}
@end
