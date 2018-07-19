//
//  PZBaseVieController.m
//  PuzGame
//
//  Created by hww on 2018/7/18.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZBaseVieController.h"
#import <SDTheme.h>
@interface PZBaseVieController ()

@end

@implementation PZBaseVieController
- (void)loadView{
    [super loadView];
    self.view.theme_backgroundColor = @"block_orange";
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageV.contentMode = UIViewContentModeScaleToFill;
    imageV.theme_image = @"bgimg";
    [self.view addSubview:imageV];
}

- (void)viewDidLoad {
    [super viewDidLoad];

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
