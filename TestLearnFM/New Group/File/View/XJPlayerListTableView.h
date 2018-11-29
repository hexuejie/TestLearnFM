//
//  XJPlayerListTableView.h
//  LearnFM
//
//  Created by 何学杰 on 2018/10/17.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJAlbumList.h"
#import "GLSlider.h"
#import "FSAudioStream.h"
#import "GLMusicPlayer.h"
#import "XJNoticeHelpView.h"
#import "public.h"

@class XJPlayerListTableView;
@protocol XJPlayerListTableViewDelegate<NSObject>

@optional

- (void)playerListTableViewClose:(XJPlayerListTableView *)view;
- (void)playerListTableViewChangeMusic:(XJPlayerListTableView *)view;
@end


@interface XJPlayerListTableView : UIView<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, weak) id<XJPlayerListTableViewDelegate> delegate;

@property (nonatomic, strong) XJAlbumList *album;

@property (nonatomic, strong) UIButton *headerButton;
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (weak, nonatomic) UIViewController *currentVC;
@property (nonatomic,assign) GLLoopState loopSate;
@property (nonatomic,strong) XJNoticeHelpView *noticeHelpView;
@end

