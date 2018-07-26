//
//  PZGameModelController.m
//  PuzGame
//
//  Created by hww on 2018/7/18.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZGameModelController.h"
#import "PZSetCell.h"



@interface PZGameModelController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataSource;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSIndexPath *selectedPath;
@end

@implementation PZGameModelController
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
    self.title = @"游戏模式";
    _dataSource = @[@"简单",@"中等",@"困难"];
    [self.view addSubview:self.tableView];
    NSInteger usPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"uspath"];
    if (usPath) {
        PZSetCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:usPath]];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"uspath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(NSInteger)nu
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    PZSetCell *cell = [PZSetCell cellWithTableView:tableView];
    NSInteger usPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"uspath"];
    if (indexPath.section == usPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.titleStr = _dataSource[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ? 0 :100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *gameModelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gameModelBtn.frame = CGRectMake(0, 0, PZ_WIDTH, 100);
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"pzgameModel"]) {
        [gameModelBtn setTitle:@"经典模式" forState:UIControlStateNormal];
    }else{
        [gameModelBtn setTitle:@"魔幻滑动" forState:UIControlStateNormal];
    }
    
    [gameModelBtn addTarget:self action:@selector(gameModelBtn:) forControlEvents:UIControlEventTouchUpInside];
    return gameModelBtn;
}
-(void)gameModelBtn:(UIButton *)sender{
    [[PZAlertManager shareManager] alertWithStyle:UIAlertControllerStyleActionSheet actions:@[@"经典模式",@"魔幻滑动"] title:nil message:nil inContrl:self action:^(NSInteger tag) {
        [sender setTitle:@[@"经典模式",@"魔幻滑动"][tag] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setInteger:tag forKey:@"pzgameModel"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"pzgameModelChange" object:nil userInfo:@{@"pzgameModel":@(tag)}];
    }];
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
        NSInteger usPath = [[NSUserDefaults standardUserDefaults] integerForKey:@"uspath"];
        PZSetCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:usPath]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        PZSetCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
        selCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.selectedPath = indexPath;
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.section forKey:@"uspath"];
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.section +3 forKey:@"diffcutly"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeModel" object:nil userInfo:@{@"diffcutly":@(indexPath.section +3)}];
    PZSetCell *selCell = [tableView cellForRowAtIndexPath:indexPath];
    selCell.accessoryType = UITableViewCellAccessoryCheckmark;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
