
//
//  PZLanchViewController.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZLanchViewController.h"
#import "PZSoundToolManger.h"
@interface PZLanchViewController ()

@end

@implementation PZLanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightTextColor];
    NSLog(@"---%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"musicOn"]);
    if (![[[NSUserDefaults standardUserDefaults] stringForKey:@"musicOn"] isEqualToString:@"noOn"]) {
        
         [[PZSoundToolManger shareSoundToolManager] playBgMusicWithPlayAgain:YES];
    }else{
        [[PZSoundToolManger shareSoundToolManager] stopBgMusic];
    }
   
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.animationfinish();
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
