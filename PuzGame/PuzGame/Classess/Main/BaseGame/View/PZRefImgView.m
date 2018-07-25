//
//  PZRefImgView.m
//  PuzGame
//
//  Created by hww on 2018/7/24.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZRefImgView.h"

@implementation PZRefImgView
- (instancetype)initWithFrame:(CGRect)frame refImgFrame:(CGRect)reFrame RefImg:(UIImage *)img{
    if (self = [super initWithFrame:frame]) {
        self.alpha = 0.35;
        UIImageView *refImgV = [[UIImageView alloc] initWithFrame:reFrame];
        refImgV.image = img;
        [self addSubview:refImgV];
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self) {
        return nil;
    } else {
        return hitView;
    }
}
@end
