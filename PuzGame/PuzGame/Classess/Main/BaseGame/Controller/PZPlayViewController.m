

//
//  PZPlayViewController.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZPlayViewController.h"
#import "XWMaskItem.h"
#import "PZSoundToolManger.h"
#import "PZSnowAction.h"
#import "SMAuotherAction.h"
#import "UIColor+SMColor.h"




#define kPzSpace 2
#define kTipLabTag 10000
#define kPzBestRecordKey @"bestRecord"

@interface PZPlayViewController ()
{
    CAEmitterLayer *flakeLayer;
    UIButton *_maxPzBtn;
    BOOL _showBgImg;
    BOOL _showTip;
    unsigned int _sound;
    NSString *_addArrStr;
    int _stepCount;
    NSInteger _bestRecord;
}
@property (nonatomic,strong) UIImageView *referImagV;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *stepLabel;
@property (nonatomic,strong) UILabel *bestRecordLabel;
@property (nonatomic,strong) UIButton *hintButton;


@property (nonatomic,strong) NSMutableArray *randNums;//存储初始化Nums
@property (nonatomic,strong) UIView *puzzleBgView;
//@property (nonatomic,strong) UIImage *puzzlebgImg;//背景图
@property (nonatomic,strong) NSMutableArray *puzzleImgArr;//分割img
@end

@implementation PZPlayViewController

- (NSMutableArray *)puzzleImgArr{
    if (!_puzzleImgArr) {
        _puzzleImgArr = [NSMutableArray array];
    }
    return _puzzleImgArr;
}
- (NSMutableArray *)randNums{
    if (!_randNums) {
        _randNums = [NSMutableArray array];
    }
    return _randNums;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    flakeLayer = [PZSnowAction snowShowWithlayerSize:CGSizeMake(self.view.bounds.size.width * 2.0, 0.0)];
    _bestRecord = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@%@",kPzBestRecordKey,self.pzImageName]];
    if (_bestRecord != INT_MAX) {
        self.bestRecordLabel.text = [NSString stringWithFormat:@"你的最佳记录:%ld步",(long)_bestRecord];
    }

    _stepCount = 0;
    _sound = 1104;
    //    _difficulty = 3;
    _puzzleCount = _difficulty *_difficulty;
    _showBgImg = YES;
//    self.puzzlebgImg = self;

    [self cutPuzzleImg:[self checkWithImg:self.puzzlebgImg]];
    self.randNums = nil;
    [self.randNums addObjectsFromArray:[self getRandNums]];
    [self creatUI];
}
-(void)creatUI{
    
    UIButton *restBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  
    [restBtn setTitle:@"重置" forState:UIControlStateNormal];
    [restBtn theme_setTitleColor:@"text_h1" forState:UIControlStateNormal];
    restBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [restBtn sizeToFit];
    [restBtn addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarbutton = [[UIBarButtonItem alloc] initWithCustomView:restBtn];
    // 设置导航条的按钮
    self.navigationItem.rightBarButtonItem = leftBarbutton;
    [_puzzleBgView removeFromSuperview];
    CGFloat pzBgViewX = 25;
    CGFloat pzBgViewY = 200;
    CGFloat pzBgViewW = PZ_WIDTH - 50;
    CGFloat pzBgViewH = pzBgViewW;
    
    _referImagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pzBgViewW /5, pzBgViewH/5)];
    _referImagV.contentMode = UIViewContentModeScaleAspectFill;
    CGPoint center = _referImagV.center;
    center.x =  PZ_WIDTH/2;
    center.y =  130;
    _referImagV.center = center;
    _referImagV.image = [self checkWithImg:self.puzzlebgImg];
    [self.view addSubview:_referImagV];
    _puzzleBgView = [[UIView alloc] initWithFrame:CGRectMake(pzBgViewX, pzBgViewY, pzBgViewW, pzBgViewH)];
    _puzzleBgView.backgroundColor = [UIColor colorWithHexColorString:@"#999999" andAlpha:1.0];
    _puzzleBgView.layer.shadowColor = [UIColor colorWithHexColorString:@"#333333" andAlpha:1.0].CGColor;
    _puzzleBgView.layer.borderColor = [UIColor colorWithHexColorString:@"#666666" andAlpha:1.0].CGColor;
    _puzzleBgView.layer.borderWidth = 0.5;
    [self.view addSubview:_puzzleBgView];
    
    _stepLabel  = [[UILabel alloc] init];
    _stepLabel.theme_textColor = @"text_h1";
    _stepLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_stepLabel];
    _bestRecordLabel = [[UILabel alloc] init];
    _bestRecordLabel.textColor = [UIColor colorWithHexColorString:@"#FF0000" andAlpha:1.0];
    _bestRecordLabel.text = @"你的最佳记录：∞";
    _bestRecordLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_bestRecordLabel];
    
    _stepLabel.text = [NSString stringWithFormat:@"%d",_stepCount];
    [_stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(self->_referImagV.mas_top).offset(0);
    }];
    [_bestRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_referImagV.mas_top).offset(0);
        make.right.equalTo(@-15);
    }];
    
    
    CGFloat pzBtnX = 0;
    CGFloat pzBtnY = 0;
    CGFloat pzBtnW = pzBgViewW / _difficulty -kPzSpace *2;
    CGFloat pzBtnH = pzBtnW;
    
    for (int i = 0; i <_puzzleCount; i ++) {
        pzBtnX = i %_difficulty *(pzBtnW +kPzSpace *2) + kPzSpace;
        pzBtnY = i / _difficulty *(pzBtnW + kPzSpace *2) +kPzSpace;
        UIButton *pzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pzBtn.frame = CGRectMake(pzBtnX, pzBtnY, pzBtnW, pzBtnH);
        pzBtn.tag = i;
        pzBtn.clipsToBounds = YES;
        [_puzzleBgView addSubview:pzBtn];
        
        int pzValue = [self.randNums[i] intValue];
        if (pzValue == _puzzleCount -1) {
            pzBtn.backgroundColor = [UIColor clearColor];
            _maxPzBtn = pzBtn;
        }else{
            if (_showBgImg) {
                [pzBtn setBackgroundImage:self.puzzleImgArr[pzValue] forState:UIControlStateNormal];
                [pzBtn setBackgroundImage:self.puzzleImgArr[pzValue] forState:UIControlStateHighlighted];
                
                CGFloat tipLbW = 15;
                CGFloat tipLbH = tipLbW;
                CGFloat tipLbX = pzBtnW - tipLbW;
                CGFloat tipLbY = pzBtnH - tipLbH;
                
                UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(tipLbX, tipLbY, tipLbW, tipLbH)];
                tipLb.tag = i + kTipLabTag;
                tipLb.layer.cornerRadius = tipLbW * 0.5;
                tipLb.layer.masksToBounds = YES;
                tipLb.text = [NSString stringWithFormat:@"%d", pzValue + 1];
                tipLb.font = [UIFont systemFontOfSize:8];
                tipLb.alpha = 0.6;
                tipLb.hidden = YES;
                tipLb.textAlignment = NSTextAlignmentCenter;
                tipLb.backgroundColor = [UIColor whiteColor];
                [pzBtn addSubview:tipLb];
            }else{
                [pzBtn setTitle:[NSString stringWithFormat:@"%d", pzValue + 1] forState:UIControlStateNormal];
                pzBtn.backgroundColor = [UIColor colorWithRed:0x4A / 255.0 green:0xC2 / 255.0 blue:0xFB / 255.0 alpha:1];
            }
              [pzBtn addTarget:self action:@selector(pzBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    _hintButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_hintButton setTitle:@"显示提醒" forState:UIControlStateNormal];
    _hintButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_hintButton theme_setTitleColor:@"text_h1" forState:UIControlStateNormal];
    [_hintButton addTarget:self action:@selector(tipsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hintButton];
    [_hintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_puzzleBgView.mas_bottom).offset(20);
        make.centerX.equalTo(@0);
    }];
}
- (void)pzBtnAction:(UIButton *)pzBtn{
    NSInteger index = pzBtn.tag;
    //top
    NSInteger upIndex = index - _difficulty;
    if (upIndex >=0 &&[self.randNums[upIndex] intValue] == _puzzleCount -1) {
        CGPoint maxPzBtnCenter = _maxPzBtn.center;
        CGPoint pzBtnCenter = pzBtn.center;
        _maxPzBtn.tag = index;
        pzBtn.tag = upIndex;
        self.randNums[upIndex] = @([self.randNums[index] integerValue]);
        self.randNums[index] = @(_puzzleCount -1);
        [UIView animateWithDuration:0.35 animations:^{
            pzBtn.center = maxPzBtnCenter;
            self->_maxPzBtn.center = pzBtnCenter;
        }];
        [self isfinish];
        return;
    }
    //down
    NSInteger downIndex = index + _difficulty;
    if (downIndex <=_puzzleCount -1 &&[self.randNums[downIndex] intValue] == _puzzleCount -1 ) {
        CGPoint maxPzBtnCenter = _maxPzBtn.center;
        CGPoint pzBtnCenter = pzBtn.center;
        _maxPzBtn.tag = index;
        pzBtn.tag = downIndex;
        self.randNums[downIndex] = @([self.randNums[index] integerValue]);
        self.randNums[index] = @(_puzzleCount -1);
        [UIView animateWithDuration:0.35 animations:^{
            pzBtn.center = maxPzBtnCenter;
            self->_maxPzBtn.center = pzBtnCenter;
        }];
        [self isfinish];
        return;
    }
    //left
    NSInteger leftIndex = index -1;
    if (index %_difficulty > 0 &&[self.randNums[leftIndex] intValue] == _puzzleCount -1) {
        CGPoint maxPzBtnCenter = _maxPzBtn.center;
        CGPoint pzBtnCenter = pzBtn.center;
        _maxPzBtn.tag = index;
        pzBtn.tag = leftIndex;
        self.randNums[leftIndex] = @([self.randNums[index] integerValue]);
        self.randNums[index] = @(_puzzleCount -1);
        [UIView animateWithDuration:0.35 animations:^{
            pzBtn.center = maxPzBtnCenter;
            self->_maxPzBtn.center = pzBtnCenter;
        }];
        [self isfinish];
        return;
    }
    //right
    NSInteger rightIndex = index +1;
    if (index %_difficulty < _difficulty -1 &&[self.randNums[rightIndex] intValue] == _puzzleCount -1) {
        CGPoint maxPzBtnCenter = _maxPzBtn.center;
        CGPoint pzBtnCenter = pzBtn.center;
        _maxPzBtn.tag = index;
        pzBtn.tag = rightIndex;
        self.randNums[rightIndex] = @([self.randNums[index] integerValue]);
        self.randNums[index] = @(_puzzleCount -1);
        [UIView animateWithDuration:0.35 animations:^{
            pzBtn.center = maxPzBtnCenter;
            self->_maxPzBtn.center = pzBtnCenter;
        }];
        [self isfinish];
        return;
    }
}
-(void)isfinish{
    _stepCount ++;
    self.stepLabel.text = [NSString stringWithFormat:@"%d",_stepCount];
    AudioServicesPlaySystemSound(_sound);
    NSInteger count = 0;
    for (int i = 0; i < _puzzleCount; i ++) {
        if ([self.randNums[i] intValue] != i) {
            return;
        }
        count ++;
    }
    if (count == _puzzleCount) {
        NSLog(@"挑战成功");
        [[NSUserDefaults standardUserDefaults] setInteger:_stepCount forKey:[NSString stringWithFormat:@"%@%@",kPzBestRecordKey,self.pzImageName]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.view.layer addSublayer:flakeLayer];
        [self alertWithTitle:@"恭喜你过关啦" message:@"" actionTitle:@"" inControl:self action:^{
            
        }];
    }
}
-(void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle inControl:(UIViewController *)controller action:(void (^)(void))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
    UIAlertAction *actionAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
//    [alert addAction:actionCancle];
    [alert addAction:actionAction];
    [controller presentViewController:alert animated:YES completion:nil];
}
-(NSArray *)getRandNums{
    int pzCount = 0;
    while (1) {
        NSMutableArray *intializeNums = [NSMutableArray array];
        for (int i = 0; i < _puzzleCount; i ++) {
            [intializeNums addObject:@(i)];
        }
        NSMutableArray *randNums = [NSMutableArray array];
        for (int i = 0; i <_puzzleCount; i ++) {
            int random = arc4random() % intializeNums.count;
            [randNums addObject:intializeNums[random]];
            [intializeNums removeObjectAtIndex:random];
        }
        //判断是否可还原
        pzCount = 0;
        
        int curNum = 0;
        int nextNum = 0;
        for (int i = 0; i <_puzzleCount; i ++) {
            curNum = [randNums[i] intValue];
            if (curNum == _puzzleCount -1) {
                pzCount += _difficulty -1 -(i / _difficulty);
                pzCount += _difficulty -1 -(i %_difficulty);
            }
            for (int j = i +1; j < _puzzleCount; j ++) {
                nextNum = [randNums[j] intValue];
                if (curNum > nextNum) {
                    pzCount ++;
                }
            }
        }
        
        if (!(pzCount %2)) {//对2求余，余0，逆序数为偶数，即偶排列；否则，为奇排列
            return randNums;
        }
    }
}
- (void)tipsBtnAction:(UIButton *)sender {
    //    1104
    
    if (!_showBgImg) {
        return;
    }
    _showTip = !_showTip;
    
    if (_showTip) {
        [sender setTitle:@"关闭提示" forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"显示提示" forState:UIControlStateNormal];
    }
    
    int i = 0;
    for (UIButton *puzzleBtn in _puzzleBgView.subviews) {
        
        UILabel *tipLb = [puzzleBtn viewWithTag:kTipLabTag + i];
        
        if (tipLb) {
            tipLb.hidden = !_showTip;
        }
        i++;
    }
    
    
}

- (void)refreshAction:(UIButton *)sender {
    
    _stepCount = 0;
    self.stepLabel.text = @"0";
    
    if (_showBgImg) {
        [self cutPuzzleImg:[self checkWithImg:self.puzzlebgImg]];
    }
    self.randNums = nil;
    [self.randNums addObjectsFromArray:[self getRandNums]];
    [self creatUI];
}
#pragma mark - Other
- (void)cutPuzzleImg:(UIImage *)img {

    self.puzzleImgArr = nil;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat puzzleBtnW = screenW / _difficulty;
    CGFloat multi = img.size.width / screenW;
    CGFloat imgX = 0;
    CGFloat imgY = 0;
    CGFloat imgW = (screenW / _difficulty - kPzSpace * 2) * multi;
    CGFloat imgH = imgW;
    
    for (int i = 0; i < _puzzleCount; i++) {
        imgX = (i % _difficulty * (puzzleBtnW + kPzSpace * 2) + kPzSpace) * multi;
        imgY = (i / _difficulty * (puzzleBtnW + kPzSpace * 2) + kPzSpace) * multi;
        // 切割图片
        CGRect rect = CGRectMake(imgX, imgY, imgW, imgH);
        CGImageRef imgRef = CGImageCreateWithImageInRect(img.CGImage, rect);
        [self.puzzleImgArr addObject:[UIImage imageWithCGImage:imgRef]];
    }
    
}
-(UIImage *)checkWithImg:(UIImage *)img{
    UIImage *tempImg = nil;
    if (fabs(img.size.width - img.size.height) < 2) {
        tempImg = img;
    } else {
        CGFloat x;
        CGFloat y;
        CGFloat w;
        CGFloat h;
        if (img.size.width > img.size.height) {
            x = (img.size.width - img.size.height) * 0.5;
            y = 0;
            w = img.size.height;
            h = w;
        } else {
            x = 0;
            y = (img.size.height - img.size.width) * 0.5;
            w = img.size.width;
            h = w;
        }
        CGImageRef imgRef = CGImageCreateWithImageInRect(img.CGImage, CGRectMake(x, y, w, h));
        tempImg = [UIImage imageWithCGImage:imgRef];
    }
    return tempImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self openCamera:nil];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [flakeLayer removeFromSuperlayer];
    flakeLayer = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
@end