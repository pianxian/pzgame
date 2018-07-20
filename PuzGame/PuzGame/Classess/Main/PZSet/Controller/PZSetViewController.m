//
//  PZSetViewController.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZSetViewController.h"
#import "PZSetCell.h"
#import "PZGameModelController.h"
#import "PZBackTypeVieController.h"
#import "PZSoundToolManger.h"
@interface PZSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataSource;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISwitch *pzSw;
@end
//游戏模式
//游戏主题
//背景音乐

@implementation PZSetViewController
-(UISwitch *)pzSw{
    if (!_pzSw) {
        _pzSw = [[UISwitch alloc] init];
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"musicOn"] isEqualToString:@"noOn"]) {
            _pzSw.on = NO;
        }else{
            _pzSw.on = YES;
        }
      
        [_pzSw addTarget:self action:@selector(pzSw:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pzSw;
}
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
    self.title = @"设置";
    _dataSource = @[@"游戏模式",@"游戏主题",@"背景音乐"];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    return cell;
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    PZSetCell *cell = [PZSetCell cellWithTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 2) {
      cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessiblityView.hidden = NO;
        [cell.accessiblityView addSubview:self.pzSw];
        self.pzSw.frame = CGRectMake(60, 10, 40, 30);
    }
    
    cell.titleStr = _dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            PZGameModelController *gameModel = [[PZGameModelController alloc] init];
            [self.navigationController pushViewController:gameModel animated:YES];
        }
            break;
        case 1:
        {
            PZBackTypeVieController *type = [[PZBackTypeVieController alloc] init];
            [self.navigationController pushViewController:type animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)pzSw:(UISwitch *)sw{
    NSString *isOn = nil;
    if (sw.on) {
        [[PZSoundToolManger shareSoundToolManager] playBgMusicWithPlayAgain:YES];
        isOn = @"On";
    }else{
        [[PZSoundToolManger shareSoundToolManager] stopBgMusic];
        isOn = @"noOn";
    }
    [[NSUserDefaults standardUserDefaults] setObject:isOn forKey:@"musicOn"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

@end
