//
//  PZPlayViewController.h
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZBaseVieController.h"

@interface PZPlayViewController : PZBaseVieController
@property (nonatomic,assign) int difficulty;
@property (nonatomic,assign) int puzzleCount;
@property (nonatomic,strong) UIImage *puzzlebgImg;
@property (nonatomic,copy) NSString *pzImageName;
@property (nonatomic,assign) PZGameModel gameModel;

@end
