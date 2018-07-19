//
//  XWMaskItem.m
//  XWSuperWidgetDemo
//
//  Created by 王剑石 on 17/1/6.
//  Copyright © 2017年 王剑石. All rights reserved.
//

#import "XWMaskItem.h"

@implementation XWMaskItem

-(instancetype)initWithMaskItem:(void (^)(XWMaskItem *))maskBlock{
    
    if (self = [super init]) {
        
        if (maskBlock) {
            maskBlock(self);
        }
        if (self.maskPath) {
            
            self.maskShap = SHAPE_CUSTOME;
        }
    }
    return self;
}

@end
