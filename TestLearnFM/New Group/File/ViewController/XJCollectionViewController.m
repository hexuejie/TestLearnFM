//
//  XJCollectionViewController.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/20.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJCollectionViewController.h"
#import "public.h"
#import "XJAlbumCollectionViewCell.h"
#import "GLMusicListViewController.h"
#import "LXToolsHTTPRequest.h"
#import "UIViewController+Extension.h"
#import "FCFileManager.h"
#import "Masonry.h"
#import "XJCollectionReusableView.h"
#import "XJAlbumTitle.h"
#import "XJAlbumAllData.h"

@interface XJCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong) XJAlbumAllData *allData;
@property (nonatomic, strong) LXToolsHTTPRequest *request;

@end

@implementation XJCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"专辑列表";
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
    [self.collectionView registerClass:[XJAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"AlbumCollectionViewCell"];
    [self.collectionView registerClass:[XJCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XJCollectionReusableView"];
    
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[[UIImage imageNamed:@"backImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsZero;
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
        button.contentEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
        button.imageEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
    }
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[backButtonItem];
    

    [self contentRefresh];
}

- (LXToolsHTTPRequest *)request{
    if (_request == nil) {
        _request = [LXToolsHTTPRequest new];
    }
    return _request;
}

-(NSMutableArray *)dataArray{
    if (_dataArray != nil){
        return _dataArray;
    }
    _dataArray = [NSMutableArray array];
    return _dataArray;
}

-(UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout != nil){
        return _flowLayout;
    }
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth = floorf((ScreenWidth-14)/3.0);
    _flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    return _flowLayout;
}

-(UICollectionView *)collectionView{
    if (_collectionView != nil){
        return _collectionView;
    }
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    
    _collectionView.scrollsToTop = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.alwaysBounceVertical = true;
    _collectionView.allowsSelection = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    return _collectionView;
}


- (void)contentRefresh{
    self.allData = [self.request albumGetLocalData];
    if (self.allData != nil) {
        self.dataArray = self.allData.list.mutableCopy;
        [self.collectionView reloadData];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.request albumRequestSuccess:^(id  _Nonnull object) {
        weakSelf.allData = object;
        weakSelf.dataArray = weakSelf.allData.list.mutableCopy;
        [weakSelf.collectionView reloadData];
        
        
    } fail:^(FAILCODE stateCode, NSString * _Nonnull error) {
        //请求失败提示空空r如也
    }];
}



#pragma mark collectionViewDelegate-collectionViewDatesource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   return self.dataArray.count+1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        
        return self.allData.myAudios.count;
    }else{
        XJAlbumTitle *albumTitle = self.dataArray[section-1];
        return albumTitle.albums.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XJAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.audios = self.allData.myAudios[indexPath.row];
    }else{
        XJAlbumTitle *albumTitle = self.dataArray[indexPath.section-1];
        cell.album = albumTitle.albums[indexPath.row];
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        GLMusicListViewController * musicList = [[GLMusicListViewController alloc]init];
        
        musicList.audios = self.allData.myAudios[indexPath.row];
        XJAlbumList *tempAlbum = [XJAlbumList new];
        tempAlbum.name = musicList.audios.name;
        tempAlbum.img = musicList.audios.typeImg;
        musicList.album = tempAlbum;
        [self.navigationController pushViewController:musicList animated:YES];
    }else{
        GLMusicListViewController * musicList = [[GLMusicListViewController alloc]init];
        
        XJAlbumTitle *albumTitle = self.dataArray[indexPath.section-1];
        musicList.album = albumTitle.albums[indexPath.row];
        
        [self.navigationController pushViewController:musicList animated:YES];
    }
}

#pragma mark  定义每个UICollectionView的纵向间距

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 5, 0, 5);//30
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth = floorf((ScreenWidth-14)/3.0);
    return CGSizeMake(itemWidth, itemWidth+12 +18);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
    }else{
        XJAlbumTitle *albumTitle = self.dataArray[section-1];
        if (albumTitle.albums.count == 0) {
            return CGSizeZero;
        }
    }
    return CGSizeMake(ScreenWidth, 35+17);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    XJCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XJCollectionReusableView" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.columnLabel.text = @"我的收藏";
    }else{
        XJAlbumTitle *albumTitle = self.dataArray[indexPath.section-1];
        headerView.columnLabel.text = albumTitle.name;
    }
   
    return headerView;
}

-(void)backAction:(id)sender{
    if (self.navigationController != nil && self.navigationController.viewControllers.count <= 1){
        [self dismiss:^{
            
        }];
    }
    [self popViewController:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.allData != nil) {
        [self.collectionView reloadData];
    }
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark    禁止横屏
-(BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
