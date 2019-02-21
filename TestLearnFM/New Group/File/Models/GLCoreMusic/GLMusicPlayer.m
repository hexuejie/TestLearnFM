//
//  GLMusicPlayer.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/10/24.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "FSAudioStream.h"
#import "GLMusicPlayer.h"
#import "XJLyricJson.h"
#import "GLMiniMusicView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <notify.h>
#import "UIImageView+WebCache.h"
#import "XJMusicList.h"
#import "XJAlbumList.h"
#import "MBProgressHUD.h"

@interface GLMusicPlayer()

@property (nonatomic,strong) CADisplayLink *progressTimer;
@property (nonatomic) FSStreamPosition frontTimePlayed;
@end

@implementation GLMusicPlayer

+ (instancetype)defaultPlayer
{
    static GLMusicPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FSStreamConfiguration *config = [[FSStreamConfiguration alloc] init];
        config.httpConnectionBufferSize *=2;
        config.enableTimeAndPitchConversion = YES;
        
        
        player = [[super alloc] initWithConfiguration:config];
        player.delegate = (id)self;
        player.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
            //播放错误
            //有待解决
            switch (error) {
                case kFsAudioStreamErrorOpen:
                    errorDescription = @"在线音乐，访问错误。";//@"Cannot open the audio stream";
                    break;
                case kFsAudioStreamErrorStreamParse:
                    errorDescription = @"在线音乐，加载错误。";//@"Cannot read the audio stream";
                    break;
                case kFsAudioStreamErrorNetwork:
                    errorDescription = @"网络错误，不能播放。";//@"Network failed: cannot play the audio stream";
                    break;
                case kFsAudioStreamErrorUnsupportedFormat:
                    errorDescription = @"当前格式不支持。";//@"Unsupported format";
                    break;
                case kFsAudioStreamErrorStreamBouncing:
                    errorDescription = @"网络错误，不能继续播放。";//@"Network failed: cannot get enough data to play";
                    break;
                default:
                    errorDescription = @"发生未知错误";//@"Unknown error occurred";
                    break;
            }
            NSLog(@"errorDescription %@",errorDescription);
//            if (error&&!player.isError) {
//                player.isError = YES;
//                [player playFont];
//            }
        };
        player.onCompletion = ^{
            //播放完成
            
        };
    
        
        player.onStateChange = ^(FSAudioStreamState state) {
            

            switch (state) {
                case kFsAudioStreamPlaying:
                {
                    player.isPause = NO;
                    
                    [GLMiniMusicView shareInstance].palyButton.selected = YES;
                    [[GLMiniMusicView shareInstance] playedWithAnimated:YES];
                }
                    break;
                case kFsAudioStreamStopped:
                {
//                    NSLog(@" 打印信息  stop.....%@",player.url.absoluteString);
                }
                    break;
                case kFsAudioStreamPaused:
                {
                    //pause
                    player.isPause = YES;
                    [GLMiniMusicView shareInstance].palyButton.selected = NO;
                    [[GLMiniMusicView shareInstance] pausedWithAnimated:YES];
                }
                    break;
                case kFsAudioStreamPlaybackCompleted:
                {
                   
                    [player playMusicForState];
                }
                    break;
                default:
                    break;
            }
        };
        //设置音量
        [player setVolume:0.5];
        //设置播放速率
        [player setPlayRate:1];
        
//        player.loopState = GLOnceLoop;
    });
    return player;
}



#pragma mark == private method

- (void)updateProgress
{
    if (self.glPlayerDelegate && [self.glPlayerDelegate respondsToSelector:@selector(updateProgressWithCurrentPosition:endPosition:)])
    {
        [self.glPlayerDelegate updateProgressWithCurrentPosition:self.currentTimePlayed endPosition:self.duration];
    }
    
    [self showLockScreenCurrentTime:(self.currentTimePlayed.second + self.currentTimePlayed.minute * 60) totalTime:(self.duration.second + self.duration.minute * 60)];
}



#pragma mark == private method - 锁屏展示部分
- (void)showLockScreenCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime
{
  
    if ([GLMusicPlayer defaultPlayer].isLocked) {//
        NSMutableDictionary *musicInfoDict = [[NSMutableDictionary alloc] init];

        UIImageView *albumImage = [UIImageView new];
        albumImage.contentMode = UIViewContentModeScaleAspectFill;
        [albumImage sd_setImageWithURL:[NSURL URLWithString:[GLMusicPlayer defaultPlayer].album.img] placeholderImage:[UIImage imageNamed:@"album_collection_background"]];
        UIImage *image = albumImage.image;
         MPMediaItemArtwork *albumArt = [ [MPMediaItemArtwork alloc] initWithImage:image];
        //设置歌曲题目
        [musicInfoDict setObject:[GLMusicPlayer defaultPlayer].currentTitle forKey:MPMediaItemPropertyTitle];
        [musicInfoDict setObject:albumArt forKey:MPMediaItemPropertyArtwork ];
//        //设置歌手名
//        [musicInfoDict setObject:@"" forKey:MPMediaItemPropertyArtist];
        //设置专辑名
        [musicInfoDict setObject:[GLMusicPlayer defaultPlayer].album.name forKey:MPMediaItemPropertyAlbumTitle];
        //设置歌曲时长
        [musicInfoDict setObject:[NSNumber numberWithFloat:totalTime]
                          forKey:MPMediaItemPropertyPlaybackDuration];
        //设置已经播放时长
        [musicInfoDict setObject:[NSNumber numberWithFloat:currentTime]
                          forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];

        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:musicInfoDict];
    }
}


//不同状态下 播放歌曲
- (void)playMusicForState
{
    if ([self.glPlayerDelegate respondsToSelector:@selector(updateStateWithCurrent:)])
    {
        [self.glPlayerDelegate updateStateWithCurrent:self];
    }
    
    switch (self.loopState) {
        case GLForeverLoop:
        {
            [self playMusicAtIndex:self.currentIndex];
        }
            break;

        case GLOnceLoop:
        {
            if (self.currentIndex == self.musicListArray.count-1) {
                [self playMusicAtIndex:0];
//                [self stop];
            }else{
                [self playMusicAtIndex:self.currentIndex + 1];
            }
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark == overloading
- (void)play
{
    if (self.currentTitle.length == 0) {
        return;
    }
    [super play];
    [self createTimer];
}

- (void)playFromURL:(NSURL *)url////播放歌曲
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //根据地址 在本地找歌词
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"musiclist" ofType:@"plist"]];
    for (XJMusicList *temp in self.allArray) {
        if ([temp.audioUrl isEqualToString:url.absoluteString]) {
            self.currentTitle = temp.name;
            if (temp.isCollection == YES) {
                [GLMusicPlayer defaultPlayer].album.name = temp.collectionName;
//                [GLMusicPlayer defaultPlayer].album.img = temp.;
            }
            [userDefaults setObject:temp.radioId forKey:@"radioId"];
            [userDefaults setObject:temp.music_id forKey:@"music_id"];
            [userDefaults setObject:temp.collectionName forKey:@"collectionName"];
            [userDefaults setObject:[NSString stringWithFormat:@"%d",temp.isCollection] forKey:@"isCollection"];

            NSLog(@"写入成功 写入成功 写入成功 写入成功    \n %@   %@",temp.radioId,temp.music_id);
            break;
        }
    }
    
    [self stop];

    if (![url.absoluteString isEqualToString:self.url.absoluteString]) {
        [super playFromURL:url];
    }else{
        [self play];
    }
    
    NSLog(@" 当前播放歌曲:%@",self.currentTitle);
    
    GLMiniMusicView *tempView = [GLMiniMusicView shareInstance];
    tempView.titleString = self.currentTitle;
    self.model = self.allArray[self.currentIndex];
    
    self.musicLRCArray = self.model.lyricJsonArray;
    
    if (![self.musicListArray containsObject:url]) {
        [self.musicListArray addObject:url];
    }
    
    //更新主界面歌词UI
    if (self.glPlayerDelegate && [self.glPlayerDelegate respondsToSelector:@selector(updateMusicLrc)])
    {
        [self.glPlayerDelegate updateMusicLrc];
    }
    _currentIndex = [self.musicListArray indexOfObject:url];
    
    [self createTimer];
}

- (void)playFromOffset:(FSSeekByteOffset)offset
{
    [super playFromOffset:offset];
    [self createTimer];
}

- (void)createTimer
{
    if (!_progressTimer) {
        _progressTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
        [_progressTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
    }
}

- (void)stop
{
    [super stop];
    if (_progressTimer) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }
}


#pragma mark == public method
- (void)playMusicAtIndex:(NSUInteger)index
{
    if (index < self.musicListArray.count) {
        _currentIndex = index;
        [self stop];
        [self playFromURL:[self.musicListArray objectAtIndex:index]];
    }
}

- (void)playFont
{
    if (self.currentIndex == 0) {
        [self playMusicAtIndex:self.musicListArray.count-1];
    }else{
        [self playMusicAtIndex:self.currentIndex - 1];
    }
}

- (void)playNext
{
    if (self.currentIndex == self.musicListArray.count-1) {
        [self playMusicAtIndex:0];
    }else{
        [self playMusicAtIndex:self.currentIndex + 1];
    }

}
#pragma mark == setter
- (void)setLoopState:(GLLoopState)loopState
{
    _loopState = loopState;
}


#pragma mark == 懒加载

- (NSMutableArray *)musicListArray
{
    if (nil == _musicListArray) {
        _musicListArray = [[NSMutableArray alloc] init];
    }
    return _musicListArray;
}



@end

