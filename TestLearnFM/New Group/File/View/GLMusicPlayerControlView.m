//
//  GLMusicPlayerControlView.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMusicPlayerControlView.h"
#import "XJMusicList.h"

@interface GLMusicPlayerControlView ()

@property (nonatomic, strong) NSMutableArray *collections;
@end

@implementation GLMusicPlayerControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView
{
//    [super awakeFromNib];
    
    
    _slider = [[GLSlider alloc]initWithFrame:CGRectMake(57, 16, ScreenWidth-57*2, 26)];
    [self addSubview:_slider];
    [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    _leftTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 19, 42, 21)];
    [self addSubview:_leftTimeLable];
    _leftTimeLable.textColor = [UIColor whiteColor];
    _leftTimeLable.font = [UIFont systemFontOfSize:12];
    _leftTimeLable.textAlignment = NSTextAlignmentCenter;
    
    _rightTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-52, 19, 42, 21)];
    [self addSubview:_rightTimeLable];
    _rightTimeLable.textColor = [UIColor whiteColor];
    _rightTimeLable.font = [UIFont systemFontOfSize:12];
    _rightTimeLable.textAlignment = NSTextAlignmentCenter;
    
    _palyMusicButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-32, 53, 64, 64)];
    [self addSubview:_palyMusicButton];
    [_palyMusicButton setImage:[UIImage imageNamed:@"miniplayer_btn_pause_normal"] forState:UIControlStateNormal];
    [_palyMusicButton setImage:[UIImage imageNamed:@"miniplayer_btn_play_normal"] forState:UIControlStateSelected];
    [_palyMusicButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
   
    _collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60-16, 53, 60, 60)];
    [self addSubview:_collectionButton];
    [_collectionButton setImage:[UIImage imageNamed:@"music_collection"] forState:UIControlStateNormal];
    [_collectionButton setImage:[UIImage imageNamed:@"music_collection_selected"] forState:UIControlStateSelected];
    [_collectionButton addTarget:self action:@selector(collectionSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _playModeButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 53, 60, 60)];
    [self addSubview:_playModeButton];
    [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_repeat_normal"] forState:UIControlStateNormal];
//    [_playModeButton setImage:[UIImage imageNamed:@"music_collection_selected"] forState:UIControlStateSelected];
    [_playModeButton addTarget:self action:@selector(changePlayMode:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _frontMusicButton = [[UIButton alloc]initWithFrame:CGRectMake(16+60, 53, 60, 60)];
    [self addSubview:_frontMusicButton];
    [_frontMusicButton setImage:[UIImage imageNamed:@"player_btn_pre_normal"] forState:UIControlStateNormal];
//    [_frontMusicButton setImage:[UIImage imageNamed:@"player_btn_pre"] forState:UIControlStateSelected];
    [_frontMusicButton addTarget:self action:@selector(frontMusic:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextMusicButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60-16-64, 53, 64, 64)];
    [self addSubview:_nextMusicButton];
    [_nextMusicButton setImage:[UIImage imageNamed:@"player_btn_next_normal"] forState:UIControlStateNormal];
//    [_nextMusicButton setImage:[UIImage imageNamed:@"player_btn_next"] forState:UIControlStateSelected];
    [_nextMusicButton addTarget:self action:@selector(nextMusic:) forControlEvents:UIControlEventTouchUpInside];

    
    [_playModeButton setImage:[UIImage imageNamed:@"miniplayer_btn_list"] forState:UIControlStateNormal];
    
    
    [_collectionButton addTarget:self action:@selector(collectionSelectedClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [docPath stringByAppendingPathComponent:kCollectionFile];
//    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
//    NSArray *tempDataArray = [XJMusicList parseArrayDic:tempArray];
//    self.collections = tempDataArray.mutableCopy;
    [self reloadPlayerControlViewSelected];
}

- (void)reloadPlayerControlViewSelected{
    self.collectionButton.selected = [GLMusicPlayer defaultPlayer].model.hasFavorite;
    
//    for (XJMusicList *temp in self.collections) {
//        if ([[GLMusicPlayer defaultPlayer].model.music_id isEqualToString:temp.music_id]) {
//            self.collectionButton.selected = YES;
//        }
//    }
}

- (void)setCurrentVC:(UIViewController *)currentVC{
    _currentVC = currentVC;
    
    [self.noticeHelpView showNotice];
    self.noticeHelpView.alpha = 0.0;
}

#pragma mark == event responder
- (void)sliderValueChange:(GLSlider *)slider
{
    if (self.palyMusicButton.selected) {
        [self play:self.palyMusicButton];
    }
    [[GLMusicPlayer defaultPlayer] play];
    
    FSStreamPosition position = {};
    unsigned totalSeconds = [GLMusicPlayer defaultPlayer].duration.minute*60 + [GLMusicPlayer defaultPlayer].duration.second;
    unsigned currentSeconds = totalSeconds * slider.value;
    
    position.second = currentSeconds % 60;
    position.minute = currentSeconds / 60;
    
    [[GLMusicPlayer defaultPlayer] seekToPosition:position];
}

- (IBAction)frontMusic:(UIButton *)sender
{
    if (sender.selected == YES) {
        return;
    }
    [[GLMusicPlayer defaultPlayer] playFont];
    self.slider.value = 0;
    if ([self.delegate respondsToSelector:@selector(musicPlayerControlViewFront:)]){
        [self.delegate musicPlayerControlViewFront:self];
    }
}

- (IBAction)play:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    //pause对应pause
    /*
     如果流播放，则在调用暂停时暂停流播放。
     否则(流暂停)，调用暂停将继续播放。
     */
    [[GLMusicPlayer defaultPlayer] pause];
    
    if ([self.delegate respondsToSelector:@selector(musicPlayerControlViewPaly:)]){
        [self.delegate musicPlayerControlViewPaly:self];
    }
}

- (IBAction)nextMusic:(UIButton *)sender
{
    if (sender.selected == YES) {
        return;
    }
    [[GLMusicPlayer defaultPlayer] playNext];
    self.slider.value = 0;
    if ([self.delegate respondsToSelector:@selector(musicPlayerControlViewNext:)]){
        [self.delegate musicPlayerControlViewNext:self];
    }
}

- (IBAction)changePlayMode:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(musicPlayerControlViewListShow:)]){
        [self.delegate musicPlayerControlViewListShow:self];
    }
    
}

- (void)collectionSelectedClick:(UIButton *)button{
    button.selected = !button.selected;
    if(button.selected){
        [self.noticeHelpView showNotice];
        self.noticeHelpView.midLabel.text = @"收藏成功";
//        [self.collections addObject:[GLMusicPlayer defaultPlayer].model];
//        [self updateCollectionToFile];
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values =  @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [button.layer addAnimation:k forKey:@"SHOW"];
        
    }else{
        [self.noticeHelpView showNotice];
        self.noticeHelpView.midLabel.text = @"取消收藏";
        
    }
    
    if ([self.delegate respondsToSelector:@selector(musicPlayerCollectionAction:)]){
        [self.delegate musicPlayerCollectionAction:self];
    }
}

- (void)updateCollectionToFile{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:kCollectionFile];
    NSMutableArray *tempDataArray = [[NSMutableArray alloc]init];
    for (XJMusicList *temp in self.collections) {
        [tempDataArray addObject:[XJMusicList parseDictionaryModel:temp]];
    }
    [tempDataArray writeToFile:filePath atomically:YES];
}

- (XJNoticeHelpView *)noticeHelpView{
    if (_noticeHelpView == nil) {
//        _noticeHelpView = [[[NSBundle mainBundle] loadNibNamed:@"LearnFM.framework/XJNoticeHelpView" owner:nil options:nil] lastObject];
        _noticeHelpView = [[XJNoticeHelpView alloc]initWithFrame:CGRectZero];
        _noticeHelpView.backgroundColor = [UIColor clearColor];
        _noticeHelpView.layer.zPosition = 10;
        _noticeHelpView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _noticeHelpView.alpha = 1.0;
        [_currentVC.view addSubview:_noticeHelpView];
    }
    return _noticeHelpView;
}

- (NSMutableArray *)collections{
    if (!_collections) {
        _collections = [[NSMutableArray alloc] init];
    }
    return _collections;
}


- (void)initialData {
    self.progress       = 0;
    self.leftTimeLable.text    = @"00:00";
    self.rightTimeLable.text      = @"00:00";
}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    self.slider.value = progress;
    
    [self.slider layoutIfNeeded];
}

@end
