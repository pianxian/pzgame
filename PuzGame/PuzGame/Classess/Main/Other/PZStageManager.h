//
//  PZStageManager.h
//  PuzGame
//
//  Created by hww on 2018/7/17.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PZStageInfo;
@interface PZStageManager : NSObject
+(instancetype)shareStageInfoManager;
- (BOOL)saveInfo:(PZStageInfo *)info;
- (BOOL)unLockNextStage;
@end
