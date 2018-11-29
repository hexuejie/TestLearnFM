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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
}



- (void)btnAction:(id)sender{
    
    
        GLMusicPlayViewController * playerVc = [GLMusicPlayViewController new];
    
//        [GLMusicPlayer defaultPlayer].authToken = @"310680911aae4e96b95f73cd5e834601";
//        [GLMusicPlayer defaultPlayer].studentid = @"f9a6f4c6574c4b70aeeeec043643ada5";
//    [GLMusicPlayer defaultPlayer].requestFM = @"http://192.168.1.181:8050/ParentServer/";
//
//    [GLMusicPlayer defaultPlayer].playingAlbumId = @"7d44d6fd-190c-4aa2-ae94-0257c01bc958";
//    [GLMusicPlayer defaultPlayer].playingMusicId = @"ab8505d5305d424081d1f698fd5390e1";
////    a475b22b-bd23-418c-99c9-fb0ac37c7262   db8adf22-cec0-46e2-aabf-263fef3bdc11
        ESNavigationController *merchantNavi = [[ESNavigationController alloc] initWithRootViewController:playerVc];
        [self presentViewController:merchantNavi animated:YES completion:nil];
}

@end
