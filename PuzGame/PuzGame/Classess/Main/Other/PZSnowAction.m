//
//  PZSnowAction.m
//  PuzGame
//
//  Created by hww on 2018/7/18.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZSnowAction.h"

@implementation PZSnowAction
+(CAEmitterLayer *)snowShowWithlayerSize:(CGSize)size{
    
    CAEmitterLayer *layer = [CAEmitterLayer layer];;
    
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    layer.emitterPosition = CGPointMake(bounds.size.width / 2, -10); //center of rectangle//发射位置
    layer.emitterSize = size;//bounds.size;//发射源的尺寸大小
    layer.emitterShape = kCAEmitterLayerLine;
    // Spawn points for the flakes are within on the outline of the line
    layer.emitterMode    = kCAEmitterLayerOutline;//发射模式
    CAEmitterCell *flakeCell = [CAEmitterCell emitterCell];
    flakeCell.contents = (id)[[UIImage imageNamed:@"FFRing"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    flakeCell.birthRate = 10;//粒子参数的速度乘数因子
    flakeCell.lifetime = 120.0;//生命周期
    flakeCell.lifetimeRange = 0.5;//生命周期范围
    
    flakeCell.velocity = -10;//速度
    flakeCell.velocityRange = 10;//速度范围
    flakeCell.yAcceleration = 10;//粒子y方向的加速度分量
    flakeCell.emissionLongitude = -M_PI / 2; // upx-y平面的发射方向  ....>> emissionLatitude：发射的z轴方向的角度
    flakeCell.emissionRange = M_PI / 4; // 90 degree cone for variety周围发射角度
    flakeCell.spinRange        = 0.25 * M_PI;        // slow spin子旋转角度范围
    flakeCell.scale = 0.5;//缩放比例：
    flakeCell.scaleSpeed = 0.1;//1.0;//缩放比例速度
    flakeCell.scaleRange = 1.0;//缩放比例范围；
    
    flakeCell.color = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];//粒子的颜色
    flakeCell.redRange = 1.0;//一个粒子的颜色red 能改变的范围；
    flakeCell.redSpeed = 0.1;//粒子red在生命周期内的改变速度；
    flakeCell.blueRange = 1.0;//一个粒子的颜色blue 能改变的范围
    flakeCell.blueSpeed = 0.1;//粒子blue在生命周期内的改变速度
    flakeCell.greenRange = 1.0;//个粒子的颜色green 能改变的范围；
    flakeCell.greenSpeed = 0.1;//粒子green在生命周期内的改变速度；
    flakeCell.alphaSpeed = -0.08;//粒子透明度在生命周期内的改变速度
    layer.emitterCells = [NSArray arrayWithObject:flakeCell];//粒子发射的粒子
    return layer;
}

@end
