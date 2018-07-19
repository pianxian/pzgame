//
//  PZSetCell.h
//  PuzGame
//
//  Created by hww on 2018/7/18.
//  Copyright © 2018年 hww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZSetCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) UIView *accessiblityView;
@end
