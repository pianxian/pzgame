
//
//  PZBackTypeVieController.m
//  PuzGame
//
//  Created by hww on 2018/7/18.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZBackTypeVieController.h"
#import "PZSetCell.h"
#import <SDTheme.h>
@interface PZBackTypeVieController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataSource;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSIndexPath *selectedPath;
@end

@implementation PZBackTypeVieController
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView= [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.theme_backgroundColor = @"block_bg";
        [_tableView setValue:self forKey:@"delegate"];
        [_tableView setValue:self forKey:@"dataSource"];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏背景";
    _dataSource = @[@"橘子橙",@"魔法灰",@"草原绿"];
    [self.view addSubview:self.tableView];
    NSInteger usPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"backType"];
    if (usPath) {
        PZSetCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:usPath inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"backType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    PZSetCell *cell = [PZSetCell cellWithTableView:tableView];
    NSInteger usPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"backType"];
    if (indexPath.row == usPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.titleStr = _dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedPath) {
        if (self.selectedPath == indexPath) {
            NSLog(@"同一个");
        }else{
            PZSetCell *orgiCell = [tableView cellForRowAtIndexPath:self.selectedPath];
            orgiCell.accessoryType = UITableViewCellAccessoryNone;
            PZSetCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
            selCell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSLog(@"不是同一个");
        }
    }else{
        NSLog(@"第一次点击");
        NSInteger usPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"backType"];
        PZSetCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:usPath inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        PZSetCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
        selCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.selectedPath = indexPath;
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"backType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PZSetCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
//    backImgTpye
    selCell.accessoryType = UITableViewCellAccessoryCheckmark;
    switch (indexPath.row) {
        case 0:
        {
            [[SDThemeManager sharedInstance] changeTheme:@"PZWhite"];
            [[NSUserDefaults standardUserDefaults] setObject:@"PZWhite" forKey:@"backImgTpye"];
        }
            break;
        case 1:
        {
             [[SDThemeManager sharedInstance] changeTheme:@"PZBlack"];
            [[NSUserDefaults standardUserDefaults] setObject:@"PZBlack" forKey:@"backImgTpye"];
        }
            break;
        case 2:
        {
            [[SDThemeManager sharedInstance] changeTheme:@"PZGreen"];
            [[NSUserDefaults standardUserDefaults] setObject:@"PZGreen" forKey:@"backImgTpye"];
        }
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
