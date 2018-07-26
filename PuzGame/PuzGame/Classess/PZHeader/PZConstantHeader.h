//
//  PZConstantHeader.h
//  PuzGame
//
//  Created by hww on 2018/7/20.
//  Copyright © 2018年 hww. All rights reserved.
//

#ifndef PZConstantHeader_h
#define PZConstantHeader_h
typedef NS_ENUM(NSInteger,PZGameModel){
    PZGameModelDefult = 0,
    PZGameModelScrol = 1
};



#define IOS_VERSION            [[[UIDevice currentDevice] systemVersion] floatValue]

#define SMCOLOR(r,g,b,a) (IOS_VERSION >=10.0f ? [UIColor colorWithDisplayP3Red:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)] : [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])
#define PZ_WIDTH [UIScreen mainScreen].bounds.size.width
#define PZ_HEIGHT [UIScreen mainScreen].bounds.size.height
#define iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.height == 1136)

#endif /* PZConstantHeader_h */
