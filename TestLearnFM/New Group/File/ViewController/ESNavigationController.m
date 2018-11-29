//
//  ESNavigationController.m
//  eShop
//
//  Created by Kyle on 14/11/27.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "ESNavigationController.h"
//#import "AppDelegate.h"
#import "UIImage+Extension.h"
#import "UIViewController+Extension.h"
#import "public.h"
#import "GLMusicPlayer.h"

@interface ESNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation ESNavigationController

- (void)dealloc
{
    self.delegate = nil;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]){
        
        self.delegate = self;
        
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:HexRGB(0x8fc96b) size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setBackgroundColor:HexRGB(0x8fc96b)];
        self.navigationBar.shadowImage = [UIImage new];
        self.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationBar.translucent = false;
        
        [self.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomNavigationBackButton];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
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



- (UIBarButtonItem *)backButtonItem
{
    if (_backButtonItem != nil) {
        return _backButtonItem;
    }
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[[UIImage imageNamed:@"backImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //    [button setImage:[[UIImage imageNamed:@"navigationBar_back_high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.imageEdgeInsets = UIEdgeInsetsZero;
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)) {
        button.contentEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
        button.imageEdgeInsets =UIEdgeInsetsMake(0, 0,0, 0);
    }
    _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return _backButtonItem;
}

- (void)setCustomNavigationBackButton
{
    UINavigationController *navi = self.navigationController;
    if (navi != nil && navi.viewControllers.count > 1){
        
        self.navigationItem.leftBarButtonItems = @[self.backButtonItem];
    }
    
}

-(void)backAction:(id)sender{
    if (self.navigationController != nil && self.navigationController.viewControllers.count <= 1){
        [self dismiss:^{
            
        }];
    }
    [self popViewController:nil];
}

-(BOOL)hidesBottomBarWhenPushed{
    return [[self lx_topMostController] hidesBottomBarWhenPushed];
}

//-(BOOL)prefersStatusBarHidden{
//    return [[self lx_topMostController] prefersStatusBarHidden];
//}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    if ([self respondsToSelector:@selector(preferredStatusBarStyle)]) {
        return [self.topViewController preferredStatusBarStyle];
    }
    
    return UIStatusBarStyleDefault;
}

// New Autorotation support.
- (BOOL)shouldAutorotate{
    
    
//    if ([self respondsToSelector:@selector(shouldAutorotate)]) {
//
//        return [self.topViewController shouldAutorotate];
//    }
//
    return NO;
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark transition

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    if ([self respondsToSelector:@selector(supportedInterfaceOrientations)]) {
//        return [self.topViewController supportedInterfaceOrientations];
//    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    if ([self respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
        
        return [self.topViewController preferredInterfaceOrientationForPresentation];
        
    }
    return UIInterfaceOrientationPortrait;
}

#pragma mark    禁止横屏
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden{
    //    NSLog(@"%s--%d",__FUNCTION__,navigationBarHidden);
}

#pragma mark    禁止横屏
- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

@end
