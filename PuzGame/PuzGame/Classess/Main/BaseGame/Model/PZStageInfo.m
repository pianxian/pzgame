//
//  PZStageInfo.m
//  PuzGame
//
//  Created by hww on 2018/7/17.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZStageInfo.h"
#import <objc/runtime.h>
#define kRank @"rank"
#define kScore @"score"
#define kUnlock @"unlock"
#define kNum @"num"
#define kimgName @"imgName"
#define kTips @"tips"
#define kName @"name"
@implementation PZStageInfo
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.num = [aDecoder decodeIntForKey:kNum];
        self.score = [aDecoder decodeDoubleForKey:kScore];
        self.unlock = [aDecoder decodeBoolForKey:kUnlock];
        self.rank = [aDecoder decodeObjectForKey:kRank];
        self.imgName = [aDecoder decodeObjectForKey:kimgName];
        self.tips = [aDecoder decodeObjectForKey:kTips];
        self.name = [aDecoder decodeObjectForKey:kName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:self.num forKey:kNum];
    [aCoder encodeDouble:self.score forKey:kScore];
    [aCoder encodeBool:self.isUnlock forKey:kUnlock];
    [aCoder encodeObject:self.rank forKey:kRank];
    [aCoder encodeObject:self.imgName forKey:kimgName];
    [aCoder encodeObject:self.tips forKey:kTips];
    [aCoder encodeObject:self.name forKey:kName];
}

+(NSArray *)property{
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    NSMutableArray *propertyList = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        objc_property_t property = propertys[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        [propertyList addObject:name];
    }
    free(propertys);
    return propertyList.copy;
}
+(PZStageInfo *)modelWithDict:(NSDictionary *)dict{
    
    PZStageInfo *info = [PZStageInfo new];
    for ( NSString *property in [self property]) {
        if ([[dict allKeys] containsObject:property]) {
            [info setValue:dict[property] forKey:property];
        }
    }
    
    return info;
}
@end
