//
//  GLMiniMusicView.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/11/10.
//  Copyright © 2017年 高磊. All rights reserved.
//  小圆形播放器指示器

#import <UIKit/UIKit.h>
#import "XJMusicList.h"
#import "XJAlbumList.h"


@class GLMiniMusicView;
@protocol GLMiniMusicViewDelegate <NSObject>

-(void)miniMusicViewPaly:(GLMiniMusicView *)view;

@end

@interface GLMiniMusicView : UIView

+ (instancetype)shareInstance;

@property (nonatomic, weak) id<GLMiniMusicViewDelegate> delegate;

@property (nonatomic, strong) XJAlbumList *album;
@property (nonatomic, strong) XJMusicList *model;
@property (nonatomic, strong) NSString *titleString;

//头图
@property (nonatomic,strong) UIImageView *imageView;
//歌曲名
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *orderLable;
//播放暂停控制按钮
@property (nonatomic,strong) UIButton *palyButton;

@property (nonatomic,strong) UIViewController *listVC;
/**
 *
 展示
 *
 **/
- (void)showView;

/**
 *
 隐藏
 *
 **/
- (void)hiddenView;


/** 播放 */
- (void)playedWithAnimated:(BOOL)animated;
/** 暂停 */
- (void)pausedWithAnimated:(BOOL)animated;
@end
