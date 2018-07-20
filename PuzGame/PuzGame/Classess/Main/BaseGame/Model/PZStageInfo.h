//
//  PZStageInfo.h
//  PuzGame
//
//  Created by hww on 2018/7/17.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZStageInfo : NSObject<NSCoding>
@property (nonatomic ,copy) NSString *rank;
@property (nonatomic,assign) int num;
@property (nonatomic,assign) double score;
@property (nonatomic,assign,getter=isUnlock) BOOL unlock;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *imgName;
@property (nonatomic,copy) NSString *tips;
//+(PZStageInfo *)modelWithDict:(NSDictionary *)dict;
@end

