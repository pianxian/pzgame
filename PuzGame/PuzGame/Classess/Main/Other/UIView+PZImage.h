//
//  UIView+PZImage.h
//  PuzGame
//
//  Created by hww on 2018/7/19.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PZImage)
- (void)setBackgroundImgWithName:(NSString *)name;
+(id)viewFromNib;
- (void)cleanSawtooth;
@end
