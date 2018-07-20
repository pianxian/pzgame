//
//  UIView+PZImage.m
//  PuzGame
//
//  Created by hww on 2018/7/19.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "UIView+PZImage.h"

@implementation UIView (PZImage)
- (void)setBackgroundImgWithName:(NSString *)name{
    
}
+(instancetype)viewFromNib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
-(void)cleanSawtooth{
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.shouldRasterize = YES;
    for (UIView *chlidV in  self.subviews) {
        [chlidV cleanSawtooth];
    }
}
@end
