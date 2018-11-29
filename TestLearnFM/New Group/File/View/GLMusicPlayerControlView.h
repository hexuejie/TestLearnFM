//
//  GLMusicPlayerControlView.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/27.
//  Copyright © 2017年 高磊. All rights reserved.
//  控制部分 暂停播放下一首等

#import <UIKit/UIKit.h>
#import "GLSlider.h"
#import "FSAudioStream.h"
#import "GLMusicPlayer.h"
#import "XJNoticeHelpView.h"
#import "public.h"

@class GLMusicPlayerControlView;
@protocol GLMusicPlayerControlViewDelegate <NSObject>

-(void)musicPlayerControlViewPaly:(GLMusicPlayerControlView *)view;
-(void)musicPlayerCollectionAction:(GLMusicPlayerControlView *)view;

-(void)musicPlayerControlViewListShow:(GLMusicPlayerControlView *)view;


-(void)musicPlayerControlViewNext:(GLMusicPlayerControlView *)view;
-(void)musicPlayerControlViewFront:(GLMusicPlayerControlView *)view;
@end


@class GLSlider;
@interface GLMusicPlayerControlView : UIView

@property (strong, nonatomic) GLSlider *slider;
//当前播放时间
@property (strong, nonatomic) UILabel *leftTimeLable;
//总时间
@property (nonatomic,strong) UILabel *rightTimeLable;
//播放、暂停按钮
@property (nonatomic,strong) UIButton *palyMusicButton;

@property (strong, nonatomic) UIButton *collectionButton;



//播放方法按钮
@property (nonatomic,strong) UIButton *playModeButton;
//前一首歌曲
@property (nonatomic,strong) UIButton *frontMusicButton;
//下一首
@property (nonatomic,strong) UIButton *nextMusicButton;


@property (nonatomic,assign) GLLoopState loopSate;
@property (nonatomic,strong) XJNoticeHelpView *noticeHelpView;

@property (weak, nonatomic) UIViewController *currentVC;

@property (nonatomic, weak) id<GLMusicPlayerControlViewDelegate> delegate;

@property (nonatomic, assign) float                             progress;

- (void)initialData;

- (void)reloadPlayerControlViewSelected;
@end
