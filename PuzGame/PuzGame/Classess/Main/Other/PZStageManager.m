//
//  PZStageManager.m
//  PuzGame
//
//  Created by hww on 2018/7/17.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZStageManager.h"
#import "PZStageInfo.h"

#define InfoName @"stageInfo"
#define path [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject  stringByAppendingPathComponent:InfoName]

@interface PZStageManager ()
@property (nonatomic,strong) NSMutableDictionary *allInfos;
@end
@implementation PZStageManager
static PZStageManager *manager = nil;
+(instancetype)shareStageInfoManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PZStageManager alloc] init];
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {

        self.allInfos = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!self.allInfos) {
            self.allInfos = [NSMutableDictionary dictionary];
            PZStageInfo *info = [PZStageInfo new];
            info.name = @"小试牛刀";
            [self.allInfos setObject:info forKey:@1];
        }
    }
    return self;
}
@end
