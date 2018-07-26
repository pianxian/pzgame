

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
#import "PZRefImgView.h"



#define kPzSpace 2
#define kTipLabTag 10000
#define kPzBestRecordKey @"bestRecord"
#define kPzBgViewX 25
#define KpzBgViewY 200
#define kPzBgViewW (PZ_WIDTH - 50)
#define kPzBgViewH (PZ_WIDTH - 50)


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
    CGFloat _orginalY;
}
@property (nonatomic,strong) UIImageView *referImagV;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *stepLabel;
@property (nonatomic,strong) UILabel *bestRecordLabel;
@property (nonatomic,strong) UIButton *hintButton;

@property (nonatomic,copy) void(^animateBlock)(void);
@property (nonatomic,strong) NSMutableArray *randNums;//存储初始化Nums
@property (nonatomic,strong) UIView *puzzleBgView;
//@property (nonatomic,strong) UIImage *puzzlebgImg;//背景图
@property (nonatomic,strong) NSMutableArray *puzzleImgArr;//分割img
@property (nonatomic,strong) PZRefImgView *refImgV;

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
    [self intilizaData];
    [self cutPuzzleImg:[self checkWithImg:self.puzzlebgImg]];
    self.randNums = nil;
    [self.randNums addObjectsFromArray:[self getRandNums]];
    [self creatUiWithGameModel:self.gameModel];
//    NSLog(@"---gameModel:%ld",_gameModel);
    if (_gameModel == PZGameModelDefult) {
        NSLog(@"经典");
    }else{
        NSLog(@"滑动");
    }
}
- (void)intilizaData{
    _bestRecord = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@%@",kPzBestRecordKey,self.pzImageName]];
    _stepCount = 0;
    _sound = 1104;
    _puzzleCount = _difficulty *_difficulty;
    _showBgImg = YES;
    _orginalY = 0;
}
-(void)creatUiWithGameModel:(PZGameModel)gameModel{
    flakeLayer = [PZSnowAction snowShowWithlayerSize:CGSizeMake(self.view.bounds.size.width * 2.0, 0.0)];
    
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

    
    _referImagV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kPzBgViewW /5, kPzBgViewH/5)];
    [_referImagV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refImgTap:)]];
    _referImagV.userInteractionEnabled = YES;
    _referImagV.contentMode = UIViewContentModeScaleAspectFill;
    CGPoint center = _referImagV.center;
    center.x =  PZ_WIDTH/2;
    center.y =  130;
    _referImagV.center = center;
    _referImagV.image = [self checkWithImg:self.puzzlebgImg];
    [self.view addSubview:_referImagV];
    
    
    [self setDefultBgView];
    
    
    _refImgV = [[PZRefImgView alloc] initWithFrame:self.view.frame refImgFrame:_puzzleBgView.frame RefImg:self.puzzlebgImg];
    
    _stepLabel  = [[UILabel alloc] init];
    _stepLabel.theme_textColor = @"text_h1";
    _stepLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_stepLabel];
    _bestRecordLabel = [[UILabel alloc] init];
    _bestRecordLabel.textColor = [UIColor colorWithHexColorString:@"#FF0000" andAlpha:1.0];
    _bestRecordLabel.text = @"你的最佳记录:∞";
    if (_bestRecord != INT_MAX && _bestRecord) {
        self.bestRecordLabel.text = [NSString stringWithFormat:@"你的最佳记录:%ld步",(long)_bestRecord];
    }
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
    CGFloat pzBtnW = kPzBgViewW / _difficulty -kPzSpace *2;
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
            if (!gameModel) {
                pzBtn.backgroundColor = [UIColor clearColor];
                _maxPzBtn = pzBtn;
            }else{
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
                
                [pzBtn setBackgroundImage:self.puzzleImgArr[pzValue] forState:UIControlStateNormal];
                [pzBtn setBackgroundImage:self.puzzleImgArr[pzValue] forState:UIControlStateHighlighted];
            }
      
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
            if (!gameModel) {
                [pzBtn addTarget:self action:@selector(pzBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
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
-(void)setDefultBgView{
    _puzzleBgView = [[UIView alloc] initWithFrame:CGRectMake(kPzBgViewX, KpzBgViewY, kPzBgViewW, kPzBgViewH)];
    _puzzleBgView.backgroundColor = [UIColor colorWithHexColorString:@"#999999" andAlpha:1.0];
    if (self.gameModel) {
        [_puzzleBgView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    }
    [self.view addSubview:_puzzleBgView];
}
-(void)pan:(UIPanGestureRecognizer *)recognizer{
    CGPoint panPoint = [recognizer locationInView:self.puzzleBgView];
//    NSLog(@"---panPoint:%@----%d----%d",NSStringFromCGPoint(panPoint),(int)(panPoint.x / kPzBgViewW *3),(int)(panPoint.y / kPzBgViewW *3));
//    if (<#condition#>) {
//        <#statements#>
//    }
    int row = (int)(panPoint.y / kPzBgViewW *3);//行
    int colm = (int)(panPoint.x / kPzBgViewW *3);//列
    int btnIndex = row *3 + colm;
    //上下移动
    int firstIndex = row *3;
    int lastIndex = row * 3 +2;
    NSLog(@"---交换前:%@",self.randNums);
    [self.randNums exchangeObjectAtIndex:firstIndex withObjectAtIndex:lastIndex];

    NSLog(@"---交换后:%@",self.randNums);
    NSArray *indexArray = @[self.randNums[row *3],self.randNums[row *3 +1],self.randNums[row *3 +2]];
//    NSLog(@"---indexarray:%@",indexArray);
//    NSLog(@"---ranindex:%d",[self.randNums[btnIndex] intValue]);
//    NSLog(@"---btnIndex:%d",btnIndex);
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
         self.bestRecordLabel.text = [NSString stringWithFormat:@"你的最佳记录:%ld步",(long)_stepCount];
        [self.view.layer addSublayer:flakeLayer];
        [[PZAlertManager shareManager] alertWithAlertControllerStyle:UIAlertControllerStyleAlert Title:@"恭喜你过关啦" message:@"" actionTitle:@"确定" inControl:self action:^{
            
        }];
        
    }
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
        [self.view addSubview:self.refImgV];
      
    } else {
        [sender setTitle:@"显示提示" forState:UIControlStateNormal];
         [self.refImgV removeFromSuperview];
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
    [self creatUiWithGameModel:self.gameModel];
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [flakeLayer removeFromSuperlayer];
    flakeLayer = nil;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)refImgTap:(UITapGestureRecognizer *)recognizer{
    
    

//    UIImageView *refImgV = [[UIImageView alloc] initWithFrame:self.view.frame];
//    refImgV.image = self.puzzlebgImg;
//    [PZAnimate animateAcion:^(PZAnimate *base) {
//        base.showAction();
//        base.hideWhenTap = YES;
//    } animationView:imgV];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//    });
}
@end
