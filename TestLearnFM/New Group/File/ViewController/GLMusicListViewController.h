//
//  GLMusicListViewController.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/26.
//  Copyright © 2017年 高磊. All rights reserved.
//  播放列表

#import <UIKit/UIKit.h>
#import "XJAlbumList.h"
#import "XJAlbumMyAudios.h"

@interface GLMusicListViewController : UIViewController

@property (nonatomic, strong) XJAlbumMyAudios *audios;
@property (nonatomic, strong) XJAlbumList *album;
@property (nonatomic, strong)NSMutableArray *dataArray;
@end
