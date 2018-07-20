//
//  PZGameViewController.m
//  PuzGame
//
//  Created by hww on 2018/7/16.
//  Copyright © 2018年 hww. All rights reserved.
//

#import "PZGameViewController.h"
#import "PZGameCell.h"
#import "PZPlayViewController.h"
#import "PZStageInfo.h"
#import "PZSetViewController.h"
#import "SMAuotherAction.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "PZStageInfo.h"
#import "PZStageManager.h"
#define PZ_GameY 130
#define PZ_SPACE 10
#define  kArchivingDataKey @"kArchivingDataKey"
#define kArchiverPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"imgarchiver"]
@interface PZGameViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
//    NSMutableArray *_titleArray;
    NSArray *_imgArray;
    NSMutableArray *_stageInfos;
    int _diffculty;
    NSInteger _imgCount;
}
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

static NSString *pzgameCell = @"pzgamecell";
static NSString *headerViewIdentifier = @"headerViewIdentifier";
static NSString *FooterView = @"FooterView";
@implementation PZGameViewController

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(PZ_SPACE + 30, PZ_GameY , PZ_WIDTH - 2 *PZ_SPACE - 60, PZ_HEIGHT - PZ_GameY) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[PZGameCell class] forCellWithReuseIdentifier:pzgameCell];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterView];
        [collectionView setValue:self forKey:@"delegate"];
        [collectionView setValue:self forKey:@"dataSource"];
        _collectionView = collectionView;
        [self.view addSubview:collectionView];
    }
    return _collectionView;
}

-(void)pzSetButtonAction{
    PZSetViewController *setView = [[PZSetViewController alloc] init];
    [self.navigationController pushViewController:setView animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self resultDataSource];
    [self intiliziaData];
    [self setUI];
    self.title = @"关卡选择";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel:) name:@"changeModel" object:nil];
    if (@available(iOS 11.0,*)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void)setUI{
    UIButton *pzSetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pzSetButton.frame = CGRectMake(PZ_WIDTH - 55, 40, 40, 40);
    [pzSetButton setBackgroundImage:[UIImage imageNamed:@"fail_button01-iphone4"] forState:UIControlStateNormal];
    [pzSetButton addTarget:self action:@selector(pzSetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pzSetButton];
}
- (void)intiliziaData{
    _imgCount = 0;
    _diffculty = 3;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"imgCount"]) {
        _imgCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"imgCount"];
    }
    NSInteger diffcutly = [[NSUserDefaults standardUserDefaults] integerForKey:@"diffcutly"];
    if (diffcutly) {
        _diffculty = (int)diffcutly;
    }
}
- (void)resultDataSource{
    [[PZStageManager shareStageInfoManager] unarchiverDataWithFilePath:kArchiverPath archiverKey:kArchivingDataKey isData:^(NSMutableArray *data) {
        for (int i = 0; i < data.count; i ++) {
            NSMutableArray *infos = data[i];
            [self.titleArray addObject:infos];
        }
    } noData:^{
        NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:@[[NSMutableArray arrayWithArray:@[@{@"name":@"xiao",@"imgName":@"spacesBound",@"tips":@"bundle"},@{@"name":@"xiao",@"imgName":@"airplane",@"tips":@"bundle"},@{@"name":@"xiao",@"imgName":@"birdnest",@"tips":@"bundle"}]],[NSMutableArray arrayWithArray:@[@{@"name":@"小试牛刀",@"imgName":@"CantonTower",@"tips":@"bundle"},@{@"name":@"小试牛刀",@"imgName":@"complex",@"tips":@"bundle"},@{@"name":@"小试牛刀",@"imgName":@"earth",@"tips":@"bundle"}]],[NSMutableArray arrayWithArray:@[@{@"name":@"小试牛刀",@"imgName":@"EiffelTower",@"tips":@"bundle"},@{@"name":@"小试牛刀",@"imgName":@"Fujisan",@"tips":@"bundle"},@{@"name":@"小试牛刀",@"imgName":@"Liberty",@"tips":@"bundle"}]]]];
        NSMutableArray *archiverMutab = [NSMutableArray array];
        for (int i = 0; i < sourceArray.count;i++) {
            NSMutableArray *archiverInfos = [NSMutableArray array];
            NSMutableArray *archiverArray = sourceArray[i];
            for (int j = 0 ;j <archiverArray.count; j ++) {
                NSDictionary *infoDict = archiverArray[j];
                PZStageInfo *info = [PZStageInfo new];
                info.tips = infoDict[@"tips"];
                info.name = infoDict[@"name"];
                info.imgName = infoDict[@"imgName"];
                [archiverInfos addObject:info];
            }
            [archiverMutab addObject:archiverInfos];
        }
        //上面已进行归档 下面进行解档
        [[PZStageManager shareStageInfoManager] archiverDataWithData:archiverMutab andKey:kArchivingDataKey filePath:kArchiverPath];
        while (self.titleArray.count < 3) {//第一次加载只有9个数据 3行 titlearray长度小于3表示还没解档完
            [[PZStageManager shareStageInfoManager] unarchiverDataWithFilePath:kArchiverPath archiverKey:kArchivingDataKey isData:^(NSMutableArray *data) {
                for (int i = 0; i < data.count; i ++) {
                    NSMutableArray *infos = data[i];
                    [self.titleArray addObject:infos];
                }
                [self.collectionView reloadData];
            } noData:^{
                
            }];
        }
    }];
}

- (void)changeModel:(NSNotification *)notification{
    NSInteger diffculty = [notification.userInfo[@"diffcutly"] integerValue];
    _diffculty = (int)diffculty;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _titleArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_titleArray[section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PZGameCell *pzcell = [collectionView dequeueReusableCellWithReuseIdentifier:pzgameCell forIndexPath:indexPath];
    pzcell.info =  _titleArray[indexPath.section][indexPath.row];
    return pzcell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((PZ_WIDTH - 2*PZ_SPACE - 60) /3, (PZ_WIDTH - 2*PZ_SPACE -60) /3);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PZPlayViewController *playView = [[PZPlayViewController alloc] init];
    PZStageInfo *info = _titleArray[indexPath.section][indexPath.row];
    UIImage *img = nil;
    if ([info.tips isEqualToString:@"file"]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths.lastObject stringByAppendingPathComponent:info.imgName];
        img = [UIImage imageWithContentsOfFile:filePath];
    }else{
        img = [UIImage imageNamed:info.imgName];
    }
    playView.pzImageName = info.imgName;
    playView.puzzlebgImg = img;
    playView.difficulty = _diffculty;
    [self.navigationController pushViewController:playView animated:YES];
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView =nil;
//    //返回段头段尾视图
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
//        //添加头视图的内容
//        header.backgroundColor = [UIColor redColor];
//        reusableView = header;
////        return reusableView;
//    }
    //如果底部视图
    if (kind ==UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *reusfooterview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterView forIndexPath:indexPath];
        reusfooterview.backgroundColor = [UIColor orangeColor];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"自定义" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.frame =  CGRectMake(0, 0, PZ_WIDTH - 2 *PZ_SPACE - 60, 100);
        [reusfooterview addSubview:addBtn];
        reusableView = reusfooterview;

    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return section == ([_titleArray count] -1)? (CGSize){PZ_WIDTH - 2 *PZ_SPACE - 60, 100} :(CGSizeZero);
}


/// 选择图片
- (void)selectImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    switch (sourceType) {
        case UIImagePickerControllerSourceTypeCamera:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                if ([SMAuotherAction checkVideoStatus]) {
                    [self presentToCamera:UIImagePickerControllerSourceTypeCamera];
                }else{
                    [SMAuotherAction videoAuthAction:^(BOOL granted) {
                        if (!granted) {
                            [self AlbumDeniedTosetWithTitle:@"相机"];
                        }else{
                            [self presentToCamera:UIImagePickerControllerSourceTypeCamera];
                        }
                    }];
                }
            }else{
                [self alertWithTitle:@"设备不支持相机" message:nil actionTitle:@"确定" inControl:self action:^{
                    
                }];
            }
        }
            break;
        case UIImagePickerControllerSourceTypePhotoLibrary:{
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                if ([SMAuotherAction isPhotoAlbumNotDetermined]){
                    // 系统弹出授权对话框
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                                // 用户拒绝，跳转到自定义提示页面
                            }else if (status == PHAuthorizationStatusAuthorized){
                                // 用户授权，弹出相册对话框
                                [self presentToCamera:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                            }
                        });
                    }];
                }else if ([SMAuotherAction isPhotoAlbumDenied]){
                    // 如果已经拒绝，则弹出对话框
                    [self AlbumDeniedTosetWithTitle:@"相册"];
                }else{//已经授权
                    [self presentToCamera:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                }
            }else{
                [self alertWithTitle:@"此设备不支持照片图库" message:nil actionTitle:@"确定" inControl:self action:^{
                    
                }];
            }
        }
        default:
            break;
    }
}
- (void)AlbumDeniedTosetWithTitle:(NSString *)title{
    
    [self alertWithTitle:[NSString stringWithFormat:@"您未允许Easy拼图访问您的%@",title] message:@"是否去设置？" actionTitle:@"去设置" inControl:self action:^{
        if( [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]] ) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{}completionHandler:^(BOOL        success) {
                }];
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}
-(void)alertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle inControl:(UIViewController *)controller action:(void (^)(void))handler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [alert addAction:actionAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)presentToCamera:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *tmpImg = info[UIImagePickerControllerEditedImage];
        self->_imgCount ++;
        [[NSUserDefaults standardUserDefaults] setInteger:self->_imgCount forKey:@"imgCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *imgNmae = [NSString stringWithFormat:@"myImg_%ld.png",self->_imgCount];
        NSString *filePath = [paths.lastObject stringByAppendingPathComponent:imgNmae];
        if ( [UIImagePNGRepresentation(tmpImg) writeToFile:filePath atomically:YES]) {
        
        }else{
            @throw [NSException exceptionWithName:@"图片保存失败" reason:@"可能图片过大或者格式不对" userInfo:nil];
        }

        NSMutableArray *mutbArray = [NSMutableArray array];
        PZStageInfo *defineInfo = [PZStageInfo new];
        defineInfo.name = @"小试牛刀";
        defineInfo.imgName = imgNmae;
        defineInfo.tips = @"file";

        [mutbArray addObject:defineInfo];
        NSMutableArray *lastArray = [self.titleArray lastObject];
        if ([lastArray count]<3) {
            [lastArray insertObject:defineInfo atIndex:lastArray.count];
            NSLog(@"不足3个不用插入下一行");
        }else{
            NSLog(@"3个需要插入下一行");
          [self.titleArray insertObject:mutbArray atIndex:self.titleArray.count];
        }

        [[PZStageManager shareStageInfoManager] archiverDataWithData:self.titleArray andKey:kArchivingDataKey filePath:kArchiverPath];
        
        [self.collectionView reloadData];
    
    }];
}

//打开相册
- (void)openCamera:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
