//
//  PZSetCell.m
//  PuzGame
//
//  Created by hww on 2018/7/18.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZSetCell.h"
#import "UIFont+fonts.h"
#import "UIColor+SMColor.h"
#import <Masonry.h>
#import <SDTheme.h>
@interface PZSetCell ()
//图标
@property (nonatomic,weak) UIImageView *iconImageView;
//标签
@property (nonatomic,weak) UILabel *tipsLabel;
//子标签
@property (nonatomic,weak) UILabel *destTitle;

//分割线
@property (nonatomic,weak) UIView *lineView;
//block
//@property (nonatomic,copy) optionBlock optionBlock;
//目标控制器
@property (nonatomic,strong)Class destVC;
//辅助视图

#define imageKey @"imageKey"
#define titleKey @"titleKey"
#define detailKey @"detailKey"
@end


@implementation PZSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"pzSetCell";
    
    PZSetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PZSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.theme_backgroundColor = @"block_bg";
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    self.iconImageView = imageView;
    [self.contentView addSubview:imageView];
    
    
    UILabel *tipslabel = [[UILabel alloc] init];
    tipslabel.font = [UIFont AvenirWithFontSize:14.0f];
    tipslabel.textColor  = [UIColor colorWithHexColorString:@"#606060" andAlpha:1.0];
    self.tipsLabel = tipslabel;
    [self.contentView addSubview:tipslabel];
    UILabel *destTitle = [[UILabel alloc] init];
    
    destTitle.font = [UIFont AvenirWithFontSize:10.0f];
    destTitle.textColor  = [UIColor colorWithHexColorString:@"#969696" andAlpha:1.0];
    self.destTitle = destTitle;
    [self.contentView addSubview:destTitle];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexColorString:@"#f0eff5" andAlpha:1.0];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
    UIView *accessiblityView = [[UIView alloc] init];
    accessiblityView.hidden = YES;
    self.accessiblityView = accessiblityView;
    [self.contentView addSubview:accessiblityView];
//        self.contentView.badgeValue = @"0";
    [self setUI];
    return self;
}
- (void)setUI{
    //图标
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(@(20));
//        make.centerY.mas_equalTo(@0);
//        make.width.mas_equalTo(@(21));
//        make.height.mas_equalTo(@23.5);
//    }];
    //label
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset = 10;
        make.right.mas_equalTo(-2);
    }];
    [self.destTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-10);
    }];
    //lineView
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@-8);
        make.height.mas_equalTo(@1);
        make.bottom.mas_equalTo(@0);
    }];
    [self.accessiblityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(@0);
        make.width.mas_equalTo(@120);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//+(instancetype)cellWithTableView:(UITableView *)tableView{
//    static NSString *identifier = @"SMMoreOtherCell";
//    SMMoreOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[SMMoreOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    return cell;
//}
//- (void)setDict:(NSDictionary *)dict{
//    _dict = dict;
//    if ([dict[imageKey] length]) {
//        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.contentView);
//            make.left.mas_equalTo(self.iconImageView.mas_right).offset = 10;
//            make.right.mas_equalTo(-2);
//        }];
//    }else{
//        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.contentView);
//            make.left.mas_equalTo(@15);
//            make.right.mas_equalTo(-2);
//        }];
//    }
//
//    self.tipsLabel.text = dict[titleKey];
//    self.iconImageView.image = SMIMAGENAME(dict[imageKey]);
//    self.destTitle.text = ([dict[detailKey] length] && ![dict[detailKey] isEqualToString:@"null"])? dict[detailKey] :@"";
//}
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.tipsLabel.text = titleStr;
    [self setNeedsDisplay];
}
@end
