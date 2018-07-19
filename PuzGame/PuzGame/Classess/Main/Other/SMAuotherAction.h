//
//  SMAuotherAction.h
//  SMJG
//
//  Created by hww on 2018/1/17.
//  Copyright © 2018年 HWW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAuotherAction : NSObject
+(BOOL)isPhotoAlbumDenied;
+ (BOOL)isPhotoAlbumNotDetermined;
//检查麦克风权限
+(BOOL) checkAudioStatus;
//获取麦克风权限
+(void)avMediaAuthor:(void (^)(BOOL granted))grantedHandler;
//检查相机权限
+ (BOOL)checkVideoStatus;
//授权相机
+(void)videoAuthAction:(void(^)(BOOL granted))grantedHandler;
@end
