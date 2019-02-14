//
//  GLMusicPlayViewController.h
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/24.
//  Copyright © 2017年 高磊. All rights reserved.
//  播放页面

#import <UIKit/UIKit.h>


@class GLMusicPlayViewController;
@protocol GLMusicPlayViewControllerDelegate <NSObject>

-(void)finishDismiss:(GLMusicPlayViewController *)ViewController;

@end


typedef void(^musicLoginBlock)(void);

typedef void(^musicBackBlock)(BOOL needLogin);

@interface GLMusicPlayViewController : UIViewController

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic,copy) musicLoginBlock loginBlock;
@property (nonatomic,copy) musicBackBlock backBlock;//定义一个MyBlock属性
@property (nonatomic, strong) NSString *playingMusicId;
@property (nonatomic, strong) NSString *playingAlbumId;

@property (nonatomic, weak) id<GLMusicPlayViewControllerDelegate> delegate;

@end
