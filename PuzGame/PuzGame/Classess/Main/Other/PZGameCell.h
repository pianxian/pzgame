//
//  PZGameCell.h
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PZStageInfo;
@interface PZGameCell : UICollectionViewCell
@property (nonatomic,strong) PZStageInfo *info;
@property (nonatomic,strong) NSDictionary *dict;
@end
