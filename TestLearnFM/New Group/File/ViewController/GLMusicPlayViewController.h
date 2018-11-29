//
//  GLMusicPlayViewController.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/24.
//  Copyright © 2017年 高磊. All rights reserved.
//  播放页面

#import <UIKit/UIKit.h>


@interface GLMusicPlayViewController : UIViewController

@property (nonatomic, assign) BOOL isPlaying;


@property (nonatomic, strong) NSString *playingMusicId;
@property (nonatomic, strong) NSString *playingAlbumId;

@end
