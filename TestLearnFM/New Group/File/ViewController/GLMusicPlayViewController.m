//
//  GLMusicPlayViewController.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/24.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "XJTokenTipsView.h"
#import "GLMusicPlayViewController.h"
#import "MBProgressHUD.h"
#import "UIViewController+Extension.h"
#import "XJLyricJson.h"
#import "MusicLRCTableViewCell.h"
#import "GLMusicLrcLable.h"
#import "GLMusicPlayer.h"
#import "GLSlider.h"
#import "GLMusicPlayerControlView.h"
#import "NSString+translation.h"
#import "FMPrefixHeader.h"
//#import "XJMusicCustomNav.h"
#import "XJNoticeHelpView.h"
#import "ESNavigationController.h"
#import "XJCollectionViewController.h"
#import "GKWYMusicCoverView.h"
//#import "GKWYMusicLyricView.h"
#import "public.h"
#import "GKWYMusicTool.h"
#import "LXToolsHTTPRequest.h"
#import "UIImage+Extension.h"
#import "Masonry.h"
#import "XJAlbumAllData.h"
#import "XJAlbumTitle.h"
#import "XJAlbumMyAudios.h"
#import "XJPlayerListTableView.h"
#import "GLMiniMusicView.h"
#import "XJAlbumList.h"
#import <AVFoundation/AVFoundation.h>
#import "GLMusicPlayer.h"

#define TableHeight ScreenHeight*3/5

@interface GLMusicPlayViewController()
<UITableViewDelegate,UITableViewDataSource,GKWYMusicCoverViewDelegate,GLMusicPlayerDelegate,UIScrollViewDelegate,GLMusicPlayerControlViewDelegate,XJPlayerListTableViewDelegate>

@property (nonatomic, strong) XJAlbumList *album;

@property (nonatomic,strong) UILabel *musicTitleLabel;

@property (nonatomic,strong) UITableView *lrcTableView;

@property (nonatomic,strong) GLMusicPlayerControlView *playerControlView;
//当前歌词所在行
@property (nonatomic,assign) NSInteger currentLcrIndex;

@property (nonatomic,assign) BOOL isDrag;

//@property (nonatomic,strong) XJMusicCustomNav *playerCustomNav;

//@property (nonatomic,strong) XJNoticeHelpView *noticeHelpView;

@property (nonatomic, strong) NSCache *cache;

@property (nonatomic, strong) GKWYMusicCoverView    *coverView;

//@property (nonatomic, strong) GKWYMusicLyricView    *lyricView;

@property (nonatomic, strong) XJPlayerListTableView *listMusicView;
@property (nonatomic, strong) UIButton *listMusicMask;

//*********************  请求需求 ******************

@property (nonatomic, strong) LXToolsHTTPRequest *request;
@end
//
@implementation GLMusicPlayViewController


#pragma mark == 懒加载
- (LXToolsHTTPRequest *)request{
    if (_request == nil) {
        _request = [LXToolsHTTPRequest new];
    }
    return _request;
}

- (XJPlayerListTableView *)listMusicView {
    if (!_listMusicView) {
        _listMusicView = [[XJPlayerListTableView alloc]initWithFrame:CGRectMake(0, ScreenHeight -TableHeight, ScreenWidth, TableHeight)];
        _listMusicView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
        _listMusicView.backgroundColor = [UIColor whiteColor];
        _listMusicView.delegate = self;
        _listMusicView.layer.zPosition = 1;
    }
    return _listMusicView;
}

- (UIButton *)listMusicMask{
    if (!_listMusicMask) {
        _listMusicMask = [[UIButton alloc]initWithFrame:self.view.bounds];
        [_listMusicMask setTitle:@"" forState:UIControlStateNormal];
        _listMusicMask.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [_listMusicMask addTarget:self action:@selector(listMusicClose) forControlEvents:UIControlEventTouchUpInside];
        //        _listMusicView.delegate = self;
    }
    return _listMusicMask;
}

- (UILabel *)musicTitleLabel
{
    if (nil == _musicTitleLabel) {
        _musicTitleLabel = [[UILabel alloc] init];
        _musicTitleLabel.textColor = [UIColor whiteColor];
        _musicTitleLabel.textAlignment = NSTextAlignmentCenter;
        _musicTitleLabel.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
        _musicTitleLabel.backgroundColor = [UIColor clearColor];
        _musicTitleLabel.lineBreakMode = NSLineBreakByClipping;
        _musicTitleLabel.numberOfLines = 2;
    }
    return _musicTitleLabel;
}

- (UITableView *)lrcTableView
{
    if (nil == _lrcTableView) {
        _lrcTableView = [[UITableView alloc] init];
        _lrcTableView.dataSource = (id)self;
        _lrcTableView.delegate = (id)self;
        _lrcTableView.separatorColor = [UIColor clearColor];
        _lrcTableView.tableFooterView = [[UITableView alloc] init];
        //LearnFM.framework/
//        [_lrcTableView registerNib:[UINib nibWithNibName:@"LearnFM.framework/MusicLRCTableViewCell" bundle:nil] forCellReuseIdentifier:@"musicLrc"];
        [_lrcTableView registerClass:[MusicLRCTableViewCell class] forCellReuseIdentifier:@"musicLrc"];
//        [self.view addSubview:self.tableView];
        _lrcTableView.backgroundColor = [UIColor clearColor];
        _lrcTableView.showsHorizontalScrollIndicator = NO;
        _lrcTableView.showsVerticalScrollIndicator = NO;
        _lrcTableView.hidden = YES;
    }
    return _lrcTableView;
}

- (GKWYMusicCoverView *)coverView {
    if (!_coverView) {
        _coverView = [GKWYMusicCoverView new];
        _coverView.delegate = self;
    }
    return _coverView;
}

- (GLMusicPlayerControlView*)playerControlView
{
    if (nil == _playerControlView) {
        NSLog(@"000");
//        [[NSBundle mainBundle] resou]
//        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"LearnFM" withExtension:@"bundle"]];
//        _playerControlView = [bundle loadNibNamed:@"GLMusicPlayerControlView" owner:nil options:nil].firstObject;
//        _playerControlView = [[[NSBundle mainBundle] loadNibNamed:@"LearnFM.framework/bundleFM.bundle/GLMusicPlayerControlView" owner:nil options:nil] lastObject];
        _playerControlView = [[GLMusicPlayerControlView alloc]initWithFrame:CGRectZero];
        NSLog(@"111");
        _playerControlView.backgroundColor = [UIColor clearColor];
        _playerControlView.currentVC = self;
        _playerControlView.delegate = self;
    }
    return _playerControlView;
}


#pragma mark - 初始化
- (id)init
{
    self = [super init];
    if (self) {
        self.currentLcrIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = HexRGB(0x8fc96b);
    [self initializeViewComponents];
    [self addViewConstraints];

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

    UIButton *albumButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    albumButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [albumButton setTitle:@"专辑 >" forState:UIControlStateNormal];
    albumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    albumButton.imageEdgeInsets = UIEdgeInsetsZero;
    [albumButton addTarget:self action:@selector(albumAction:) forControlEvents:UIControlEventTouchUpInside];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
        albumButton.contentEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
        albumButton.imageEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
    }
    UIBarButtonItem *albumButtonItem = [[UIBarButtonItem alloc] initWithCustomView:albumButton];
    self.navigationItem.rightBarButtonItems = @[albumButtonItem];


    self.playingAlbumId = [GLMusicPlayer defaultPlayer].playingAlbumId;
    self.playingMusicId  = [GLMusicPlayer defaultPlayer].playingMusicId;
    
    if (self.playingAlbumId ) {
        if (![self lookoutPlayingRadioId:self.playingAlbumId music_id:self.playingMusicId isOut:YES]) {//判断是否传值过来
            //重新请求找
            [self testMedthLookout];
        }
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *radioId = [userDefaults objectForKey:@"radioId"];
        NSString *music_id = [userDefaults objectForKey:@"music_id"];
        [self lookoutPlayingRadioId:radioId music_id:music_id isOut:NO];
    }
    

    if (self.album == nil) {//

        [self albumContentRefresh];
    }else{
//        self.title = self.album.name;
    }

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];

//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

//    //增加监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appHasGoneInForeground)
//                                                 name:UIApplicationWillEnterForegroundNotification
//                                               object:nil];
//    //别忘了删除监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appHasGoneInForeground{
    [[GLMusicPlayer defaultPlayer] play];
}

- (void)testMedthLookout{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
        [self.request musicListRequestRadioId:self.playingAlbumId Success:^(id  _Nonnull object) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [weakSelf lookoutPlayingRadioId:weakSelf.playingAlbumId music_id:weakSelf.playingMusicId isOut:YES];
        } fail:^(FAILCODE stateCode, NSString * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (error) {
                [self alertViewTitle:error];
            }else{
                [self alertViewTitle:@"服务器连接失败"];
            }
        }];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark == event response
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{

    NSLog(@"event.subtype  %ld",event.subtype);

    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            {
                //点击播放按钮或者耳机线控中间那个按钮
                [[GLMusicPlayer defaultPlayer] pause];
            }
                break;
            case UIEventSubtypeRemoteControlPause:
            {
                //点击暂停按钮
                [[GLMusicPlayer defaultPlayer] pause];
            }
                break;
            case UIEventSubtypeRemoteControlStop :
            {
                //点击停止按钮
                [[GLMusicPlayer defaultPlayer] stop];
            }
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                //点击播放与暂停开关按钮(iphone抽屉中使用这个)
                [[GLMusicPlayer defaultPlayer] pause];
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
            {
                //点击下一曲按钮或者耳机中间按钮两下
                [[GLMusicPlayer defaultPlayer] playNext];
            }
                break;
            case  UIEventSubtypeRemoteControlPreviousTrack:
            {
                //点击上一曲按钮或者耳机中间按钮三下
                [[GLMusicPlayer defaultPlayer] playFont];
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
            {
                //快退开始 点击耳机中间按钮三下不放开
            }
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
            {
                //快退结束 耳机快退控制松开后
            }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
            {
                //开始快进 耳机中间按钮两下不放开
            }
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
            {
                //快进结束 耳机快进操作松开后
            }
                break;

            default:
                break;
        }

    }
}


- (BOOL)lookoutPlayingRadioId:(NSString *)radioId music_id:(NSString *)music_id isOut:(BOOL)isOut{
    if (radioId == nil) {
        return NO;
    }

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *collectionName = [userDefaults objectForKey:@"collectionName"];
    NSString *isCollection = [userDefaults objectForKey:@"isCollection"];

    XJAlbumAllData *allData = [self.request albumGetLocalData];

    if ([isCollection integerValue] == 1 && isOut == NO) {
        //收藏的
        for (XJAlbumMyAudios *tempAudio in allData.myAudios) {
            if ([tempAudio.name isEqualToString:collectionName]) {
                XJAlbumList *tempAlbum = [XJAlbumList new];
                tempAlbum.name = tempAudio.name;
                tempAlbum.img = tempAudio.typeImg;
                tempAlbum.isPlay = YES;
                self.album = tempAlbum;
                [GLMusicPlayer defaultPlayer].album = tempAlbum;

                [GLMusicPlayer defaultPlayer].allArray = tempAudio.favoriteAudios;
                NSArray *tempList = [GLMusicPlayer defaultPlayer].allArray;

                NSMutableArray *musciList = [[NSMutableArray alloc] init];
                for (XJMusicList *temp in [GLMusicPlayer defaultPlayer].allArray) {
                    [musciList addObject:[NSURL URLWithString:temp.audioUrl]];
                    temp.isPlay = NO;
                }
                [GLMusicPlayer defaultPlayer].musicListArray = musciList;


                for (int i = 0; i<[GLMusicPlayer defaultPlayer].allArray.count; i++) {
                    XJMusicList *tempMusic = [GLMusicPlayer defaultPlayer].allArray[i];
                    if ([tempMusic.music_id isEqualToString:music_id]) {
                        tempMusic.isPlay = YES;
                        [[GLMusicPlayer defaultPlayer] playMusicAtIndex:i];
                        NSLog(@"music  ");
                    }
                }

            }

        }
        return NO;
    }else{

        //    allData.myAudios
        for (XJAlbumTitle *tempAlbumTitle in allData.list) {

            for (XJAlbumList *tempAlbum in tempAlbumTitle.albums) {
                if ([tempAlbum.catalog_id isEqualToString:radioId]) {
                    self.album = tempAlbum;
                    tempAlbum.isPlay = YES;
                    [GLMusicPlayer defaultPlayer].album = tempAlbum;
                    [GLMusicPlayer defaultPlayer].allArray = [self.request musicGetLocalDataRadioId:radioId];
                    NSArray *tempList = [GLMusicPlayer defaultPlayer].allArray;

                    NSMutableArray *musciList = [[NSMutableArray alloc] init];
                    for (XJMusicList *temp in [GLMusicPlayer defaultPlayer].allArray) {
                        [musciList addObject:[NSURL URLWithString:temp.audioUrl]];
                        temp.isPlay = NO;
                    }
                    [GLMusicPlayer defaultPlayer].musicListArray = musciList;

                    for (int i = 0; i<[GLMusicPlayer defaultPlayer].allArray.count; i++) {
                        XJMusicList *tempMusic = [GLMusicPlayer defaultPlayer].allArray[i];

                        if ([tempMusic.music_id isEqualToString:music_id] || (music_id == nil&&radioId != nil)) {
                            tempMusic.isPlay = YES;
                            [[GLMusicPlayer defaultPlayer] playMusicAtIndex:i];
                            NSLog(@"music  ");

                            return YES;
                        }
                    }
                    //            return;
                }
            }

        }
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [GLMusicPlayer defaultPlayer].glPlayerDelegate = self;

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HexRGB(0x73b04c) size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    if (_lrcTableView) {
        [self.lrcTableView reloadData];
        [self.playerControlView reloadPlayerControlViewSelected];
    }
    
    
    if ([UIApplication sharedApplication].delegate.window.frame.size.height == 812-30&&self.view.frame.size.width == 375)
    {
        self.navigationController.view.frame =  CGRectMake(0, -44, ScreenWidth, 782+44);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HexRGB(0x8fc96b) size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self musicPlayerControlViewPaly:self.playerControlView];
    [self playerControlViewUpdate];

    self.title = [GLMusicPlayer defaultPlayer].album.name;
    self.coverView.imageURL = [GLMusicPlayer defaultPlayer].album.img;
    
    
}

#pragma mark == 控件功能
-(void)musicPlayerControlViewPaly:(GLMusicPlayerControlView *)view{
    if (!self.playerControlView.palyMusicButton.selected) {
        [self.coverView playedWithAnimated:YES];
    }else{
        [self.coverView pausedWithAnimated:YES];
    }
}


-(void)musicPlayerControlViewListShow:(GLMusicPlayerControlView *)view{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    [window addSubview:self.listMusicMask];
    [window addSubview:self.listMusicView];
    self.listMusicMask.alpha = 0.0;
    self.listMusicView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    self.listMusicView.dataArray = [GLMusicPlayer defaultPlayer].allArray;
    self.listMusicView.currentVC = self;

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.listMusicMask.alpha = 1.0;
    }];
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.listMusicView.frame = CGRectMake(0, ScreenHeight-TableHeight, ScreenWidth, TableHeight);
    }];
}

- (void)listMusicClose{
    [self.listMusicView.noticeHelpView removeFromSuperview];
    if ([GLMiniMusicView shareInstance].palyButton.selected&&!self.coverView.isAnimation) {
        [self.coverView playedWithAnimated:YES];
    }

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.listMusicMask.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.listMusicMask removeFromSuperview];
    }];
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.listMusicView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
    } completion:^(BOOL finished) {
        [weakSelf.listMusicView removeFromSuperview];
    }];
}

- (void)playerListTableViewClose:(XJPlayerListTableView *)view{
    [self listMusicClose];
}

-(void)musicPlayerControlViewNext:(GLMusicPlayerControlView *)view{
    if (self.coverView.hidden == NO) {
        [self.coverView nextMusicAnimate];
    }
}

-(void)musicPlayerControlViewFront:(GLMusicPlayerControlView *)view{
    if (self.coverView.hidden == NO) {
        if (self.coverView.hidden == NO) {
            [self.coverView frontMusicAnimate];
        }
    }
}

-(void)musicPlayerCollection:(GLMusicPlayerControlView *)view State:(BOOL)state{
    view.collectionButton.selected = state;
    if(state){
        [view.noticeHelpView showNotice];
        view.noticeHelpView.midLabel.text = @"收藏成功";
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values =  @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [view.collectionButton.layer addAnimation:k forKey:@"SHOW"];
        
    }else{
        [view.noticeHelpView showNotice];
        view.noticeHelpView.midLabel.text = @"取消收藏";
    }
}

- (void)loginTips:(GLMusicPlayerControlView *)view{
    typeof(self) __weak weakSelf = self;
    view.tokentipView = [[XJTokenTipsView alloc]init];
    view.tokentipView.tipContentLabel.text = @"账号已在其他设备登录，请重新登录！";
    view.tokentipView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:view.tokentipView];
    view.tokentipView.block = ^{
        [weakSelf musicPlayerControlViewBack:view];
    };
}

#pragma mark 收藏
-(void)musicPlayerCollectionAction:(GLMusicPlayerControlView *)view{
    NSString *musicId = [GLMusicPlayer defaultPlayer].model.music_id;
    if ([GLMusicPlayer defaultPlayer].model.music_id == nil) {
        return;
    }
    view.collectionButton.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [self collectionUpdate:view.collectionButton.selected];
    if (!view.collectionButton.selected) {

        [self.request musicCollectionRequestMusicId:musicId Success:^(id  _Nonnull object) {
            view.collectionButton.enabled = YES;
            BOOL responseDictionary = [object[@"success"] boolValue];
            if (responseDictionary == NO) {
                if ([[NSString stringWithFormat:@"%@",object[@"resultCode"]] isEqualToString:@"-100"]) {
                    [self loginTips:view];
                }else if ([[NSString stringWithFormat:@"%@",object[@"resultCode"]] isEqualToString:@"-1"]) {
                    [self musicPlayerCollection:view State:YES];
                }else{
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:object[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alter addAction:action];
                    [weakSelf presentViewController:alter animated:YES completion:^{}];
                }
                
            }else{
                [self musicPlayerCollection:view State:YES];
            }
        } fail:^(FAILCODE stateCode, NSString * _Nonnull error) {
            view.collectionButton.enabled = YES;
        }];
    }else{

        [self.request musicDeleteCollectionRequestMusicId:musicId Success:^(id  _Nonnull object) {
            view.collectionButton.enabled = YES;
            BOOL responseDictionary = [object[@"success"] boolValue];
            if (responseDictionary == NO) {
                if ([[NSString stringWithFormat:@"%@",object[@"resultCode"]] isEqualToString:@"-100"]) {
                    [self loginTips:view];
                }else if ([[NSString stringWithFormat:@"%@",object[@"resultCode"]] isEqualToString:@"-1"]) {
                    [self musicPlayerCollection:view State:NO];
                }else{
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:object[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alter addAction:action];
                    [weakSelf presentViewController:alter animated:YES completion:^{}];
                }
            }else{
                [self musicPlayerCollection:view State:NO];
            }
        } fail:^(FAILCODE stateCode, NSString * _Nonnull error) {
            view.collectionButton.enabled = YES;
        }];
    }

}

- (void)collectionUpdate:(BOOL)collection{////同步数据

    XJAlbumAllData *allData = [self.request albumGetLocalData];

    for (XJAlbumTitle *tempAlbumTitle in allData.list) {//list 列表

        for (XJAlbumList *tempAlbum in tempAlbumTitle.albums) {

            if ([tempAlbum.catalog_id isEqualToString:[GLMusicPlayer defaultPlayer].model.radioId]) {

                NSMutableArray *allMusic = [self.request musicGetLocalDataRadioId:tempAlbum.catalog_id];
                NSMutableArray *allAddMusic = [NSMutableArray array];
                for (int i = 0; i<allMusic.count; i++) {
                    XJMusicList *tempMusic = allMusic[i];
                    if ([tempMusic.music_id isEqualToString:[GLMusicPlayer defaultPlayer].model.music_id]) {
                        tempMusic.hasFavorite = collection;
                        [GLMusicPlayer defaultPlayer].model.hasFavorite = collection;
                        [allMusic setObject:tempMusic atIndexedSubscript:i];
                    }
                    [allAddMusic addObject:[XJMusicList parseDictionaryModel:tempMusic]];
                }

                ;
                NSString *filePath = [NSString stringWithFormat:@"%@%@",tempAlbum.catalog_id,kMusicFile];
                [self.request writeToFileArray:allAddMusic byAppendingPath:filePath];

            }
        }
    }


    NSMutableArray *tempMyAudios = allData.myAudios.mutableCopy;
    for (int j = 0; j<tempMyAudios.count; j++) {
       XJAlbumMyAudios *tempAudios = allData.myAudios[j];

        NSMutableArray *allMusic = tempAudios.favoriteAudios.mutableCopy;

        for (int i = 0; i<allMusic.count; i++) {
            XJMusicList *tempMusic = tempAudios.favoriteAudios[i];
            if ([tempMusic.music_id isEqualToString:[GLMusicPlayer defaultPlayer].model.music_id]) {
                tempMusic.hasFavorite = collection;
                [GLMusicPlayer defaultPlayer].model.hasFavorite = collection;
                if (!collection) {
                    tempMusic.isCollection = NO;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"0" forKey:@"isCollection"];
                }

                [allMusic setObject:tempMusic atIndexedSubscript:i];
            }
        }
        tempAudios.favoriteAudios = allMusic;
        [tempMyAudios setObject:tempAudios atIndexedSubscript:j];
    }
    allData.myAudios = tempMyAudios;
    [self.request writeToFileArray:[XJAlbumAllData parseDictionaryModel:allData] byAppendingPath:kAlbumFile];
}

-(void)musicPlayerControlViewBack:(GLMusicPlayerControlView *)view{
    if (self.playerControlView.palyMusicButton.selected == NO) {
//        [[GLMusicPlayer defaultPlayer] pause];
        //点击停止按钮
        [[GLMusicPlayer defaultPlayer] stop];
    }
    self.backBlock(YES);
    [self dismiss:^{}];
    
    if (self.navigationController != nil && self.navigationController.viewControllers.count <= 1){
    }
    [self popToRootViewControllerAnimation:YES completion:nil];
}

-(void)backAction:(id)sender{
    if (self.playerControlView.palyMusicButton.selected == NO) {
        [[GLMusicPlayer defaultPlayer] stop];
    }
    
    self.backBlock(NO);
    [self dismiss:^{
        //            if ([self.delegate respondsToSelector:@selector(finishDismiss:)]){
        //                [self.delegate finishDismiss:self];
        //            }
    }];
    
    if (self.navigationController != nil && self.navigationController.viewControllers.count <= 1){
        
    }
    [self popToRootViewControllerAnimation:YES completion:nil];
}

#pragma mark == private method

- (void)initializeViewComponents
{
//    [self.playerCustomNav.backButton addTarget:self action:@selector(disMiss:) forControlEvents:UIControlEventTouchUpInside];
//    self.playerCustomNav.backgroundColor = HexRGB(0x73b04c);
//    self.playerCustomNav.titleLabel.text = [GLMusicPlayer defaultPlayer].album.name;//self.album.name;

    self.musicTitleLabel.text = [GLMusicPlayer defaultPlayer].currentTitle;

    [self.view addSubview:self.musicTitleLabel];
    [self.view addSubview:self.playerControlView];

    [self.view addSubview:self.lrcTableView];
    [self.view addSubview:self.coverView];
    self.lrcTableView.backgroundColor = [UIColor clearColor];
    self.coverView.backgroundColor = [UIColor clearColor];
    self.coverView.imageURL = [GLMusicPlayer defaultPlayer].album.img;
}

- (void)addViewConstraints
{

    [self.musicTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(100*(ScreenHeight/640) -64);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    [self.lrcTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(105*(ScreenHeight/640)-44  +80);//80
        make.bottom.equalTo(self.view.bottom).offset(-180);
        make.left.right.equalTo(self.view);
    }];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.top).offset(105*(ScreenHeight/640)-34 +50*(ScreenHeight/640));//80
        make.height.mas_equalTo(ScreenWidth-70);
    }];

    [self.playerControlView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(CURRENT_VIEW_WIDTH, 120));
        make.bottom.equalTo(self.view.bottom).offset(-20);
        make.left.equalTo(self.view.left);
    }];

    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLyricView)]];
    [self.lrcTableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCoverView)]];
}

- (void)showLyricView {
    self.lrcTableView.hidden = NO;

    [UIView animateWithDuration:0.5 animations:^{
        self.lrcTableView.alpha            = 1.0;

        self.coverView.alpha            = 0.0;
//        self.controlView.topView.alpha  = 0.0;
    }completion:^(BOOL finished) {
        self.lrcTableView.hidden           = NO;
        self.coverView.hidden           = YES;
//        self.controlView.topView.hidden = YES;
    }];
}

- (void)showCoverView {
    self.coverView.hidden           = NO;

    [UIView animateWithDuration:0.5 animations:^{
        self.lrcTableView.alpha            = 0.0;

        self.coverView.alpha            = 1.0;
    }completion:^(BOOL finished) {
        self.lrcTableView.hidden           = YES;
        self.coverView.hidden           = NO;
    }];
}

//逐行更新歌词
- (void)updateMusicLrcForRowWithCurrentTime:(NSTimeInterval)currentTime
{

    for (int i = 0; i < [GLMusicPlayer defaultPlayer].musicLRCArray.count; i ++) {
        XJLyricJson *model = [GLMusicPlayer defaultPlayer].musicLRCArray[i];

        NSInteger next = i + 1;

        XJLyricJson *nextLrcModel = nil;
        if (next < [GLMusicPlayer defaultPlayer].musicLRCArray.count) {
            nextLrcModel = [GLMusicPlayer defaultPlayer].musicLRCArray[next];
        }
//        NSLog(@"next %ld",next);
        if (self.currentLcrIndex != i && currentTime >= model.msTime)
        {
            BOOL show = NO;
            if (nextLrcModel) {
                if (currentTime < nextLrcModel.msTime) {
                    show = YES;
                }
            }else{
                show = YES;
            }

            if (show) {
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentLcrIndex inSection:0];

                self.currentLcrIndex = i;

                MusicLRCTableViewCell *currentCell = [self.lrcTableView cellForRowAtIndexPath:currentIndexPath];
                MusicLRCTableViewCell *previousCell = [self.lrcTableView cellForRowAtIndexPath:previousIndexPath];

                //设置当前行的状态
                [currentCell reloadCellForSelect:YES];
                //取消上一行的选中状态
                [previousCell reloadCellForSelect:NO];


                if (!self.isDrag) {

                    [self.lrcTableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
            }
        }

        if (self.currentLcrIndex == i) {
            MusicLRCTableViewCell *cell = [self.lrcTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.lrcLable.progress = 1.0;
        }
    }
}

#pragma mark == event response
- (void)disMiss:(UIButton *)sender
{
    if (self.navigationController != nil && self.navigationController.viewControllers.count <= 1){
        [self dismiss:^{

        }];
    }
    [self popViewController:nil];[self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark == UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GLMusicPlayer defaultPlayer].musicLRCArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicLRCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicLrc" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];

    cell.lrcModel = [GLMusicPlayer defaultPlayer].musicLRCArray[indexPath.row];

    if (indexPath.row == self.currentLcrIndex) {
        [cell reloadCellForSelect:YES];
    }else{
        [cell reloadCellForSelect:NO];
    }

    return cell;
}

#pragma mark == UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark == UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDrag = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDrag = NO;
    if ([GLMusicPlayer defaultPlayer].musicLRCArray.count == 0|| self.playerControlView.palyMusicButton.selected == YES) {
        return;
    }
    [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLcrIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark == GLMusicPlayerDelegate
- (void)updateProgressWithCurrentPosition:(FSStreamPosition)currentPosition endPosition:(FSStreamPosition)endPosition
{
    //更新进度条
    if ( currentPosition.position != 0) {
        self.playerControlView.slider.value = currentPosition.position;
    }

    self.playerControlView.leftTimeLable.text = [NSString translationWithMinutes:currentPosition.minute seconds:currentPosition.second];
    self.playerControlView.rightTimeLable.text = [NSString translationWithMinutes:endPosition.minute seconds:endPosition.second];

    //更新歌词
    [self updateMusicLrcForRowWithCurrentTime:currentPosition.position *(endPosition.minute *60 + endPosition.second)];

    self.playerControlView.palyMusicButton.selected = [GLMusicPlayer defaultPlayer].isPause;
}

-(void)albumAction:(UIButton *)view{
    XJCollectionViewController *collectionVC = [[XJCollectionViewController alloc]init];
    collectionVC.view.backgroundColor = [UIColor whiteColor];
//    ESNavigationController *merchantNavi = [[ESNavigationController alloc] initWithRootViewController:collectionVC];
    [self.navigationController pushViewController:collectionVC animated:YES];
}


- (void)updateMusicLrc
{
    [self playerControlViewUpdate];
    [self.lrcTableView reloadData];
    [self.playerControlView reloadPlayerControlViewSelected];
}

- (void)playerControlViewUpdate{
    self.musicTitleLabel.text = [GLMusicPlayer defaultPlayer].currentTitle;

    self.playerControlView.frontMusicButton.selected = NO;
    self.playerControlView.nextMusicButton.selected = NO;
}

//请求编辑的数据
- (void)albumContentRefresh{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    __weak typeof(self) weakSelf = self;
    [self.request albumRequestSuccess:^(id  _Nonnull object) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        XJAlbumAllData *allData = object;
//        allData.myAudios;  XJAlbumMyAudios

        NSArray *albums = allData.list;
        XJAlbumTitle *albumTitle = [albums firstObject];
        weakSelf.album = [albumTitle.albums firstObject];
        if (weakSelf.playingAlbumId != nil) {
            NSString *radioId = weakSelf.playingAlbumId;
            //    allData.myAudios
            for (XJAlbumTitle *tempAlbumTitle in allData.list) {

                for (XJAlbumList *tempAlbum in tempAlbumTitle.albums) {
                    if ([tempAlbum.catalog_id isEqualToString:radioId]) {
                        weakSelf.album = tempAlbum;
                        tempAlbum.isPlay = YES;
                        [GLMusicPlayer defaultPlayer].album = tempAlbum;
                        [GLMusicPlayer defaultPlayer].allArray = [weakSelf.request musicGetLocalDataRadioId:radioId];
                    }
                }
            }
        }

        [weakSelf musicContentRefresh:weakSelf.album.catalog_id];

    } fail:^(FAILCODE stateCode, NSString * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (error) {
            [self alertViewTitle:error];
        }else{
            [self alertViewTitle:@"服务器连接失败"];
        }
    }];
}

- (void)musicContentRefresh:(NSString *)catalog_id{

    __weak typeof(self) weakSelf = self;
    [self.request musicListRequestRadioId:catalog_id Success:^(id  _Nonnull object) {
        if (weakSelf.playingMusicId != nil) {
            NSString *music_id = weakSelf.playingMusicId;

            NSMutableArray *musciList = [[NSMutableArray alloc] init];
            for (XJMusicList *temp in [GLMusicPlayer defaultPlayer].allArray) {
                [musciList addObject:[NSURL URLWithString:temp.audioUrl]];
                temp.isPlay = NO;
            }
            [GLMusicPlayer defaultPlayer].musicListArray = musciList;

            for (int i = 0; i<[GLMusicPlayer defaultPlayer].allArray.count; i++) {
                XJMusicList *tempMusic = [GLMusicPlayer defaultPlayer].allArray[i];

                if ([tempMusic.music_id isEqualToString:music_id]) {
                    tempMusic.isPlay = YES;
                    [[GLMusicPlayer defaultPlayer] playMusicAtIndex:i];
                    NSLog(@"music  ");

                }
            }
        }else{
            [weakSelf playFirstMusic:object];
        }

    } fail:^(FAILCODE stateCode, NSString * _Nonnull error) {
        if (error) {
            [self alertViewTitle:error];
        }else{
            [self alertViewTitle:@"服务器连接失败"];
        }
    }];
}

- (void)playFirstMusic:(NSArray *)musicList{

    if (musicList.count > 0) {

        NSMutableArray *musciList = [[NSMutableArray alloc] init];
        for (XJMusicList *temp in musicList) {
            [musciList addObject:[NSURL URLWithString:temp.audioUrl]];
            temp.isPlay = NO;
        }
        XJMusicList *temp = [musicList firstObject];
        temp.isPlay = YES;
        self.album.isPlay = YES;

        [GLMusicPlayer defaultPlayer].allArray = musicList;
        [GLMusicPlayer defaultPlayer].musicListArray = musciList;
        [[GLMusicPlayer defaultPlayer] playMusicAtIndex:0];
        [GLMusicPlayer defaultPlayer].album = self.album;
        self.title = self.album.name;
        [GLMusicPlayer defaultPlayer].model = temp;
        //        [GLMusicPlayer defaultPlayer].currentTitle = tempModel.name;
//        [GLMiniMusicView shareInstance].palyButton.selected = YES;

    }
}


- (void)alertViewTitle:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message message:nil
                                                  delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重试",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self albumContentRefresh];
    }else{
        [self backAction:nil];
    }
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
