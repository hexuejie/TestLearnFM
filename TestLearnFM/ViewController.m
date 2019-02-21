//
//  ViewController.m
//  TestLearnFM
//
//  Created by 何学杰 on 2018/10/31.
//  Copyright © 2018年 何学杰. All rights reserved.
//

#import "ViewController.h"
#import "GLMusicPlayViewController.h"
#import "ESNavigationController.h"

#import "GLMusicPlayer.h"
//#import "GLMusicPlayer.h"
//#import <LearnFM/LearnFM.h>
#import "ColorCircleView.h"
 #import <AVFoundation/AVFoundation.h>

@interface ViewController ()<GLMusicPlayViewControllerDelegate>

@property (nonatomic, retain)AVAudioPlayer *player;
@property (nonatomic, strong) UIButton * musicbtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextField *testField = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 200, 50)];
    testField.backgroundColor = [UIColor grayColor];
    [self.view addSubview:testField];
    
    self.title = @"测试";
    UIButton * btn  = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(50, 100, 100, 60)];
    [btn setTitle:@"进去电台" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
//    NSDictionary *dic1 = @{@"strokeColor":[UIColor redColor],@"precent":@"0.2"};
//    NSDictionary *dic2 = @{@"strokeColor":[UIColor greenColor],@"precent":@"0.5"};
//    NSDictionary *dic3 = @{@"strokeColor":[UIColor grayColor],@"precent":@"0.1"};
//    NSDictionary *dic4 = @{@"strokeColor":[UIColor yellowColor],@"precent":@"0.2"};
//
//    ColorCircleView *circleView = [[ColorCircleView alloc]initWithFrame:CGRectMake(100, 250, 200, 200)];
//    circleView.circleArray = @[dic1,dic2,dic4,dic3];
//    [self.view addSubview:circleView];
//    [UIApplication sharedApplication].keyWindow.frame = CGRectMake(0, 30, 375, 812-30);
       
    
    /* 获取本地文件 */
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *urlString = [bundle pathForResource:@"Am1r-Right Now (Na Na Na)" ofType:@"mp3"];
    
    /* 初始化url */
    NSURL *url = [[NSURL alloc] initFileURLWithPath:urlString];
    
    /* 初始化音频文件 */
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    /* 加载缓冲 */
    [self.player prepareToPlay];
    
    
     _musicbtn = [[UIButton alloc]init];
    [_musicbtn addTarget:self action:@selector(musicClick:) forControlEvents:UIControlEventTouchUpInside];
    [_musicbtn setFrame:CGRectMake(150, 300, 100, 60)];
    
    [_musicbtn setTitle:@"播放" forState:UIControlStateNormal];
    [_musicbtn setTitle:@"停止" forState:UIControlStateSelected];
    [_musicbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [musicbtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _musicbtn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_musicbtn];
}

- (void)musicClick:(UIButton *)button{
    
    if (button.selected == NO) {
        [self.player play];
        button.selected = YES;
    }else{
        button.selected = NO;
        [self.player pause];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_musicbtn.selected == NO) {
   
    }else{
        _musicbtn.selected = NO;
        [self.player pause];
    }
}

- (void)btnAction:(id)sender{
    
    
    GLMusicPlayViewController * playerVc = [GLMusicPlayViewController new];
    playerVc.delegate = self;
//    [GLMusicPlayer defaultPlayer].authToken = @"e71493f8e7ff4d2e9d3885ca784bc824";
//    [GLMusicPlayer defaultPlayer].studentid = @"0d9371049f224be081e19a0266209f18";
    [GLMusicPlayer defaultPlayer].requestFM = @"http://test.api.p.ajia.cn:8080/ajiau-api/ParentServer/";
    playerVc.backBlock = ^(BOOL needLogin) {
        [GLMusicPlayer defaultPlayer].authToken = @"e71493f8e7ff4d2e9d3885ca784bc824";
        [GLMusicPlayer defaultPlayer].studentid = @"0d9371049f224be081e19a0266209f18";
    };
    playerVc.loginBlock = ^{//登录
        [GLMusicPlayer defaultPlayer].authToken = @"e71493f8e7ff4d2e9d3885ca784bc824";
        [GLMusicPlayer defaultPlayer].studentid = @"0d9371049f224be081e19a0266209f18";
    };
    
//    [GLMusicPlayer defaultPlayer].playingAlbumId = @"7d44d6fd-190c-4aa2-ae94-0257c01bc958";
//    [GLMusicPlayer defaultPlayer].playingMusicId = @"ab8505d5305d424081d1f698fd5390e1";
////    a475b22b-bd23-418c-99c9-fb0ac37c7262   db8adf22-cec0-46e2-aabf-263fef3bdc11
        ESNavigationController *merchantNavi = [[ESNavigationController alloc] initWithRootViewController:playerVc];
        [self presentViewController:merchantNavi animated:YES completion:nil];
}

-(void)finishDismiss:(GLMusicPlayViewController *)ViewController{
    NSLog(@"1111");
}
@end
