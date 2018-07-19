//
//  SMAuotherAction.m
//  SMJG
//
//  Created by hww on 2018/1/17.
//  Copyright © 2018年 HWW. All rights reserved.
//

#import "SMAuotherAction.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@implementation SMAuotherAction
+(BOOL)isPhotoAlbumDenied
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isPhotoAlbumNotDetermined
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusNotDetermined)
    {
        return YES;
    }
    return NO;
}
//检查麦克风权限
+(BOOL) checkAudioStatus{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
//            self.audioStatus = @"AVAuthorizationStatusNotDetermined";
            return NO;
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
//            self.audioStatus = @"AVAuthorizationStatusRestricted";
            return NO;
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
//            self.audioStatus = @"AVAuthorizationStatusDenied";
            return NO;
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
//            self.audioStatus = @"AVAuthorizationStatusAuthorized";
            return YES;
            break;
        default:
            break;
    }

}
    //获取麦克风权限
+(void)avMediaAuthor:(void (^)(BOOL granted))grantedHandler{

        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            NSLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
            grantedHandler(granted);
        }];
}
//检查相机权限
+ (BOOL)checkVideoStatus
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启相机
//            self.videoStatus = @"AVAuthorizationStatusNotDetermined";
            return NO;
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
//            self.videoStatus = @"AVAuthorizationStatusRestricted";
            return NO;
            break;
        case AVAuthorizationStatusDenied:
            //未授权
//            self.videoStatus = @"AVAuthorizationStatusDenied";
            return NO;
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
//            self.videoStatus = @"AVAuthorizationStatusAuthorized";
            return YES;
            break;
        default:
            break;
    }
}
//授权相机
+(void)videoAuthAction:(void(^)(BOOL granted))grantedHandler
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
        grantedHandler(granted);
    }];
}
@end
