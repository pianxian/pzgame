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
#define managePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject  stringByAppendingPathComponent:InfoName]

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

//        self.allInfos = [NSKeyedUnarchiver unarchiveObjectWithFile:managePath];
        if (!self.allInfos) {
//            self.allInfos = [NSMutableDictionary dictionary];
//            PZStageInfo *info = [PZStageInfo new];
//            info.name = @"小试牛刀";
//            [self.allInfos setObject:info forKey:@1];
        }
    }
    return self;
}
- (BOOL)saveInfo:(PZStageInfo *)info{
    return YES;
}
-(BOOL)unLockNextStage{//手动解锁下一关 后期添加需要解锁前一关 后一关才解锁
    return YES;
}
- (void)unarchiverDataWithFilePath:(NSString *)path archiverKey:(NSString *)key isData:(void(^)(NSMutableArray *data))dataAVailable noData:(void(^)(void))unAvailable{
    NSData *sourceData = [[NSMutableData alloc] initWithContentsOfFile:path];
    if (sourceData) {
        NSLog(@"已归档");
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:sourceData];
        NSMutableArray *unarchiverMutableArr = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        dataAVailable(unarchiverMutableArr);
    }else{
        NSLog(@"未找到归档文件");
        unAvailable();
    }
}
- (void)archiverDataWithData:(id)sourcedData andKey:(NSString *)key filePath:(NSString *)path{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:sourcedData forKey:key]; // archivingDate的encodeWithCoder
    [archiver finishEncoding];
    if ([data writeToFile:path atomically:YES]) {
        NSLog(@"归档成功");
    }else{
        @throw [NSException exceptionWithName:@"归档失败" reason:nil userInfo:nil];
    }
}
@end
