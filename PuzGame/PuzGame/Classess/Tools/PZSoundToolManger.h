//
//  PZSoundToolManger.h
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZSoundHeader.h"
typedef NS_ENUM(NSInteger,PZSoundPlayType){
    PZSoundPlayTypeHeight = 0,
    PZSoundPlayTypeMiddle,
    PZSoundPlayTypeLow,
    PZSoundPlayTypeMute
};

@interface PZSoundToolManger : NSObject
@property (nonatomic,assign) PZSoundPlayType bgMusicType;
@property (nonatomic,assign) PZSoundPlayType soundType;

- (void)pauseBgMusic;
- (void)stopBgMusic;
- (void)playBgMusicWithPlayAgain:(BOOL)playAgain;
- (void)playSoundWithSoundName:(NSString *)soundName;
- (void)setBackgroundMusicVolume:(float)volume;
+(instancetype)shareSoundToolManager;
@end
