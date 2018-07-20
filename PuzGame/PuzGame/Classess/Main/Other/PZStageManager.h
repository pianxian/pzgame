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

//归档并查找是否存在归档文件
- (void)unarchiverDataWithFilePath:(NSString *)path archiverKey:(NSString *)key isData:(void(^)(NSMutableArray *data))dataAVailable noData:(void(^)(void))unAvailable;
//解档
- (void)archiverDataWithData:(id)sourcedData andKey:(NSString *)key filePath:(NSString *)path;

@end
