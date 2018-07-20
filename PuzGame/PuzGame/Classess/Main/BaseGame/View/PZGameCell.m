
//
//  PZGameCell.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZGameCell.h"
#import "PZStageInfo.h"

@interface PZGameCell()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIImageView *bgImageView;
@end

@implementation PZGameCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    _titleLab = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLab];
    _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    [self addSubview:_bgImageView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor orangeColor];
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}
//- (void)setTitleText:(NSString *)titleText{
//    _titleText = titleText;
//    _titleLab.text = titleText;
//}
- (void)setInfo:(PZStageInfo *)info{
    _info = info;
    self.titleLab.text = info.name;
    if ([info.tips isEqualToString:@"file"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths.lastObject stringByAppendingPathComponent:info.imgName];
        _bgImageView.image = [UIImage imageWithContentsOfFile:filePath];
        NSLog(@"---filePath%@",filePath);
    }else{
        _bgImageView.image = [UIImage imageNamed:info.imgName];
    }
}
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
//    NSLog(@"---%@",dict);
    self.titleLab.text = dict[@"name"];

    if ([dict[@"tips"] isEqualToString:@"file"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths.lastObject stringByAppendingPathComponent:dict[@"imgName"]];
        _bgImageView.image = [UIImage imageWithContentsOfFile:filePath];
        NSLog(@"---filePath%@",filePath);
    }else{
        _bgImageView.image = [UIImage imageNamed:dict[@"imgName"]];
    }
}
@end
