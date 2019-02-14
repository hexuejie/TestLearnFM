//
//  GLMusicListViewController.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicListViewController.h"
#import "GLMusicPlayViewController.h"
#import "LXToolsHTTPRequest.h"
#import "GLMusicPlayer.h"
#import "GLMiniMusicView.h"
#import "FMPrefixHeader.h"
#import "XJMusicTableViewCell.h"
#import "UIViewController+Extension.h"

@interface GLMusicListViewController ()<UITableViewDelegate,UITableViewDataSource,GLMiniMusicViewDelegate,GLMusicPlayerDelegate>

@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) GLMiniMusicView *musicView;
@property (nonatomic,strong) NSIndexPath * selectedIndex;
@property (nonatomic, strong) LXToolsHTTPRequest *request;
@property (nonatomic, strong) UITableView *tableView;

@end
////  *0.42666666

@implementation GLMusicListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
//        self.musicListDic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"musiclist" ofType:@"plist"]];
        
    }
    return self;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
//         self.musicListDic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"musiclist" ofType:@"plist"]];
    }
    return self;
}

#pragma mark == 懒加载

- (LXToolsHTTPRequest *)request{
    if (_request == nil) {
        _request = [LXToolsHTTPRequest new];
    }
    return _request;
}

- (UIView *)header{
    if (_header == nil) {
        _header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 66+10+8)];
        [_header addSubview:self.musicView];
    }
    return _header;
}

-(NSMutableArray *)dataArray{
    if (_dataArray != nil){
        return _dataArray;
    }
    _dataArray = [NSMutableArray array];
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [GLMusicPlayer defaultPlayer].glPlayerDelegate = self;
    
    //    [[GLMiniMusicView shareInstance] showView];
    [GLMiniMusicView shareInstance].listVC = self;
    if (self.dataArray.count > 0) {
        [self.tableView reloadData];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [GLMusicPlayer defaultPlayer].glPlayerDelegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _album.name;
    [self showMusicView];
    [self initTableVIew];
    
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

    if (self.audios == nil) {
        [self contentRefresh];
    }else{
        self.title = self.audios.name;
        self.dataArray = self.audios.favoriteAudios.mutableCopy;
        XJAlbumList *tempAlbum = self.album;
        if (tempAlbum.radioAudioCount == 0) {
            tempAlbum.radioAudioCount = self.audios.favoriteAudios.count;
        }
        [self.tableView reloadData];
    }
    
    [GLMusicPlayer defaultPlayer].isLocked = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LockScreenNotifyClick) name:@"LockScreenNotify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnLockScreenNotifyClick) name:@"UnLockScreenNotify" object:nil];
}

- (void)LockScreenNotifyClick{
    [GLMusicPlayer defaultPlayer].isLocked = YES;
}
- (void)UnLockScreenNotifyClick{
    [GLMusicPlayer defaultPlayer].isLocked = NO;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)contentRefresh{
    
    self.dataArray = [self.request musicGetLocalDataRadioId:self.album.catalog_id];
    if (self.dataArray.count > 0) {
        [self.tableView reloadData];
    }
    
    __weak typeof(self) weakSelf = self;
    [self.request musicListRequestRadioId:self.album.catalog_id Success:^(id  _Nonnull object) {
        weakSelf.dataArray = object;
        if (weakSelf.musicView.model == nil) {
            weakSelf.musicView.model = weakSelf.dataArray.firstObject;
        }
        [weakSelf.tableView reloadData];
    } fail:^(FAILCODE stateCode, NSString * _Nonnull error) {
        //请求失败提示空空r如也
    }];
}

- (void)showMusicView{
    self.musicView = [GLMiniMusicView shareInstance];
    self.musicView.delegate = self;
    self.musicView.backgroundColor = [UIColor whiteColor];
    self.musicView.frame = CGRectMake(8, 10, ScreenWidth-16, 66);
    self.musicView.layer.cornerRadius = 6;
    self.musicView.layer.masksToBounds = YES;
    if ([GLMusicPlayer defaultPlayer].album != nil) {
        self.musicView.album = [GLMusicPlayer defaultPlayer].album;
    }
    [self.view addSubview:self.header];
    self.header.backgroundColor = HexRGB(0xf0f0f3);
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(66+10+8);
    }];
}

- (void)initTableVIew{
    
//    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = HexRGB(0xf0f0f3);
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];//;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollsToTop = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.allowsSelection = YES;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[XJMusicTableViewCell class] forCellReuseIdentifier:@"musiclist"];
    [self.view addSubview:self.tableView];
    
    self.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:9999];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_bottom);
        make.bottom.equalTo(self.view);
        make.leading.equalTo(self.view).offset(8);
        make.trailing.equalTo(self.view).offset(-8);
    }];
    self.tableView.layer.cornerRadius = 6;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = HexRGB(0xf0f0f3);
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musiclist" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    [[GLMiniMusicView shareInstance] playedWithAnimated:YES];
    
    XJMusicList *tempMusic = self.dataArray[indexPath.row];
    if ([[GLMusicPlayer defaultPlayer].model.music_id isEqualToString:tempMusic.music_id]) {
        [GLMiniMusicView shareInstance].palyButton.selected = YES;
        
        NSMutableArray *musciList = [[NSMutableArray alloc] init];
        for (XJMusicList *temp in self.dataArray) {
            [musciList addObject:[NSURL URLWithString:temp.audioUrl]];
            temp.isPlay = NO;
        }
        
        tempMusic.isPlay = YES;
        self.album.isPlay = YES;
        
        [GLMusicPlayer defaultPlayer].allArray = self.dataArray;
        [GLMusicPlayer defaultPlayer].musicListArray = musciList;
        [GLMusicPlayer defaultPlayer].currentIndex = indexPath.row;
        [GLMusicPlayer defaultPlayer].album = self.album;
        [GLMiniMusicView shareInstance].palyButton.selected = YES;
        self.musicView.album = self.album;
        
        [self.tableView reloadData];
        
        GLMusicPlayViewController *playerVc;
        for (id tempVC in self.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[GLMusicPlayViewController class]]) {
                playerVc = tempVC ;
            }
        }
        [self.navigationController popToViewController:playerVc animated:YES];
        
    }else{
        
        NSMutableArray *musciList = [[NSMutableArray alloc] init];
        for (XJMusicList *temp in self.dataArray) {
            [musciList addObject:[NSURL URLWithString:temp.audioUrl]];
            temp.isPlay = NO;
        }
        
        tempMusic.isPlay = YES;
        self.album.isPlay = YES;
        
        [GLMusicPlayer defaultPlayer].allArray = self.dataArray;
        [GLMusicPlayer defaultPlayer].musicListArray = musciList;
        [[GLMusicPlayer defaultPlayer] playMusicAtIndex:indexPath.row];
        [GLMusicPlayer defaultPlayer].album = self.album;
//        [GLMusicPlayer defaultPlayer].model = tempModel;
//        [GLMusicPlayer defaultPlayer].currentTitle = tempModel.name;
        [GLMiniMusicView shareInstance].palyButton.selected = YES;
        self.musicView.album = self.album;
        
        [self.tableView reloadData];
    }
    self.selectedIndex = indexPath;
//    playerVc.album = self.album;
//    [self presentViewController:playerVc animated:YES completion:^{
//    }];
}

-(void)miniMusicViewPaly:(GLMiniMusicView *)view{
    [self.tableView reloadData];
}

- (void)updateStateWithCurrent:(GLMusicPlayer *)currentPosition{
    [self.tableView reloadData];
}
-(void)backAction:(id)sender{
    if (self.navigationController != nil && self.navigationController.viewControllers.count <= 1){
        [self dismiss:^{
            
        }];
    }
    [self popViewController:nil];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark    禁止横屏
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
