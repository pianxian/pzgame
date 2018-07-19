//
//  PZSoundToolManger.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZSoundToolManger.h"
#import <AVFoundation/AVFoundation.h>

#define kMusicType @"kMusicType"
#define kSoundType @"kSoundType"

@interface PZSoundToolManger ()
{
    BOOL _loadData;
}
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSMutableDictionary *soundIDs;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


static PZSoundToolManger *instance = nil;
@implementation PZSoundToolManger
+(instancetype)shareSoundToolManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ PZSoundToolManger alloc] init];
    });
    return instance;
}
- (instancetype)init{
    if (self = [super init]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        _loadData = YES;
        self.bgMusicType = [[NSUserDefaults standardUserDefaults] integerForKey:kMusicType];
        self.soundType = [[NSUserDefaults standardUserDefaults] integerForKey:kSoundType];
        [self loadSounds];
    }
    return self;
}
- (AVAudioPlayer *)player{
    if (!_player) {
        NSURL *bgMusicURL = [[NSBundle mainBundle] URLForResource:kBgMusicURLName withExtension:nil];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:bgMusicURL error:nil];
        [_player prepareToPlay];
        _player.numberOfLoops = -1;
        _player.volume = [self volumOfSoundPlayType:[[NSUserDefaults standardUserDefaults] integerForKey:kMusicType]];
        AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume, audioVolumeChange, NULL);
    }
    return _player;
}
- (void)setBgMusicType:(PZSoundPlayType)bgMusicType{
    _bgMusicType = bgMusicType;
    [[NSUserDefaults standardUserDefaults] setInteger:bgMusicType forKey:kMusicType];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.player.volume = [self volumOfSoundPlayType:bgMusicType];
    if (!_loadData) {
        if (bgMusicType == PZSoundPlayTypeMute) {
            [self.player stop];
        }else{
            [self.player play];
        }
    }
    _loadData = NO;
}
-(void)setSoundType:(PZSoundPlayType)soundType{
    _soundType = soundType;
    [[NSUserDefaults standardUserDefaults] setInteger:soundType forKey:kSoundType];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    switch (soundType) {
        case PZSoundPlayTypeHeight:
            [self setSoundVolumn:1.0f];
            break;
            case PZSoundPlayTypeMiddle:
            [self setSoundVolumn:0.65];
            break;
            case PZSoundPlayTypeLow:
            [self setSoundVolumn:0.35];
            break;
            case PZSoundPlayTypeMute:
            [self setSoundVolumn:0];
            break;
        default:
            break;
    }
}
-(void)playBgMusicWithPlayAgain:(BOOL)playAgain{
    if ([self currentVolumn] == 0) {
        [self.player pause];
        return;
    }
    if (self.bgMusicType == PZSoundPlayTypeMute) {
        [self.player stop];
        return;
    }
    if ([self isOtherMusicPlaying]) {
        [self.player stop];
        return;
    }
    if (playAgain) {
        [self.player stop];
    }
    [self.player play];
}
- (void)pauseBgMusic{
    [self.player pause];
}
- (void)stopBgMusic{
    [self.player stop];
}
- (void)playSoundWithSoundName:(NSString *)soundName{
    if (self.soundType == PZSoundPlayTypeMute) return;
    if (![self currentVolumn])return;
    [self loadSounds];
    SystemSoundID soundID = [self.soundIDs[soundName] unsignedIntValue];
    
    AudioServicesPlaySystemSound(soundID);
}
- (void)setBackgroundMusicVolume:(float)volume {
    [self.player setVolume:volume];
}
#pragma mark 音量改变
void audioVolumeChange(void *inUserData, AudioSessionPropertyID inPropertyID,
                       UInt32 inPropertyValueSize, const void *inPropertyValue)
{
    // 1.获得音量
    Float32 value = *(Float32 *)inPropertyValue;
    
    // 2.根据当前音量决定播放还是暂停背景音乐
    if (value > 0) {
        [[PZSoundToolManger shareSoundToolManager] playBgMusicWithPlayAgain:YES];
    } else {
        [[PZSoundToolManger shareSoundToolManager] pauseBgMusic];
    }
}
- (void)loadSounds{
    if (self.soundIDs)return;
    self.soundIDs = [NSMutableDictionary dictionary];
    NSURL *boundleURL = [[NSBundle mainBundle] URLForResource:kSoundURLName withExtension:nil];
    NSBundle *soundBundle = [NSBundle bundleWithURL:boundleURL];
    NSArray *boundsURLs = [soundBundle URLsForResourcesWithExtension:@"mp3" subdirectory:nil];
    for (NSURL *soundURL in boundsURLs) {
        [self loaSoundWithURL:soundURL];
    }
}
- (void)loaSoundWithURL:(NSURL *)url{
    NSString *soundPath = [url.path lastPathComponent];
    if ([self.soundIDs objectForKey:soundPath])return;
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    [self.soundIDs setObject:@(soundID) forKey:soundPath];
}
- (float)volumOfSoundPlayType:(PZSoundPlayType)playType{
    float volume;
    
    switch (playType) {
        case PZSoundPlayTypeHeight:
            volume = 1.0;
            break;
        case PZSoundPlayTypeMiddle:
            volume= 0.65;
            break;
        case PZSoundPlayTypeLow:
            volume = 0.35;
            break;
        case PZSoundPlayTypeMute:
            volume = 0;
            break;
        default:
            break;
    }
    
    return volume;
}
#pragma mark 是否有其他音乐正在播放
- (BOOL)isOtherMusicPlaying {
    UInt32 playing;
    UInt32 dataSize = sizeof(UInt32);
    
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying,
                            &dataSize,
                            &playing);
    
    return playing;
}
#pragma mark 获得当前的音量
- (float)currentVolumn {
    float volume;
    UInt32 dataSize = sizeof(float);
    
    AudioSessionGetProperty (kAudioSessionProperty_CurrentHardwareOutputVolume,
                             &dataSize,
                             &volume);
    return volume;
}
- (void)setSoundVolumn:(float) volumn {
    //    [[AVAudioSession sharedInstance] setValue:@(volumn) forKey:@"outputVolume"];
    AudioSessionSetProperty(kAudioSessionProperty_CurrentHardwareOutputVolume,
                            sizeof(float),
                            &volumn);
}
#pragma clang diagnostic pop
@end
