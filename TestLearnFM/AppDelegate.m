//
//  AppDelegate.m
//  TestLearnFM
//
//  Created by 何学杰 on 2018/10/31.
//  Copyright © 2018年 何学杰. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
//#import <LearnFM/LearnFM.h>
//#import <AVFoundation/AVFoundation.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        ViewController *test = [[ViewController alloc]init];
        test.view.backgroundColor = [UIColor whiteColor];
    
        [self.window setRootViewController:test];
        [self.window makeKeyAndVisible];
    
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
//        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    return YES;
}


- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application{
    NSLog(@"锁屏");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LockScreenNotify"
                                                        object:nil];
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application{
    NSLog(@"解锁");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnLockScreenNotify"
                                                        object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application NS_AVAILABLE_IOS(4_0){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LockScreenNotify"
                                                        object:nil];
}
- (void)applicationWillEnterForeground:(UIApplication *)application NS_AVAILABLE_IOS(4_0){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnLockScreenNotify"
                                                        object:nil];
}

//#pragma mark == event response
//-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
//
//        NSLog(@"%ld",event.subtype);
//
//        if (event.type == UIEventTypeRemoteControl) {
//            switch (event.subtype) {
//                case UIEventSubtypeRemoteControlPlay:
//                {
//                    //点击播放按钮或者耳机线控中间那个按钮
//                    [[GLMusicPlayer defaultPlayer] pause];
//                }
//                    break;
//                case UIEventSubtypeRemoteControlPause:
//                {
//                    //点击暂停按钮
//                    [[GLMusicPlayer defaultPlayer] pause];
//                }
//                    break;
//                case UIEventSubtypeRemoteControlStop :
//                {
//                    //点击停止按钮
//                    [[GLMusicPlayer defaultPlayer] stop];
//                }
//                    break;
//                case UIEventSubtypeRemoteControlTogglePlayPause:
//                {
//                    //点击播放与暂停开关按钮(iphone抽屉中使用这个)
//                    [[GLMusicPlayer defaultPlayer] pause];
//                }
//                    break;
//                case UIEventSubtypeRemoteControlNextTrack:
//                {
//                    //点击下一曲按钮或者耳机中间按钮两下
//                    [[GLMusicPlayer defaultPlayer] playNext];
//                }
//                    break;
//                case  UIEventSubtypeRemoteControlPreviousTrack:
//                {
//                    //点击上一曲按钮或者耳机中间按钮三下
//                    [[GLMusicPlayer defaultPlayer] playFont];
//                }
//                    break;
//                case UIEventSubtypeRemoteControlBeginSeekingBackward:
//                {
//                    //快退开始 点击耳机中间按钮三下不放开
//                }
//                    break;
//                case UIEventSubtypeRemoteControlEndSeekingBackward:
//                {
//                    //快退结束 耳机快退控制松开后
//                }
//                    break;
//                case UIEventSubtypeRemoteControlBeginSeekingForward:
//                {
//                    //开始快进 耳机中间按钮两下不放开
//                }
//                    break;
//                case UIEventSubtypeRemoteControlEndSeekingForward:
//                {
//                    //快进结束 耳机快进操作松开后
//                }
//                    break;
//
//                default:
//                    break;
//            }
//
//        }
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
