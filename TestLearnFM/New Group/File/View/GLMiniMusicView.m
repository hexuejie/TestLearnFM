//
//  GLMiniMusicView.m
//  GLMusicBox
//
//  Created by 高磊 on 2017/11/10.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLMiniMusicView.h"
#import "GLMusicPlayer.h"
//#import "AppDelegate.h"
#import "FMPrefixHeader.h"
#import "GLMusicPlayViewController.h"
#import "UIImageView+WebCache.h"
#import "public.h"

static CGFloat const kShowBarHeight = 66;
static CGFloat const kMiniMusicImageWidth = 52;
static CGFloat const kMiniMusicImageHeight = 52;
static CGFloat const kMiniMusicPlayWidth = 32;
static CGFloat const kMiniMusicPlayHeight = 32;

@interface GLMiniMusicView()<UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
/** 定时器 */
@property (nonatomic, strong) CADisplayLink     *displayLink;

@end

@implementation GLMiniMusicView

+ (instancetype)shareInstance
{
    static GLMiniMusicView *miniMusicView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        miniMusicView = [[GLMiniMusicView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kShowBarHeight)];
    });
    
    return miniMusicView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UICOLOR_FROM_RGB_OxFF(0xdedede);
        [self addViews];
        [self addViewConstraint];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch:)];
        self.tapGesture.delegate = (id)self;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)addViews
{
    
    [self addSubview:self.orderLable];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLable];
    [self addSubview:self.palyButton];
}

- (void)addViewConstraint
{

    
    [self.palyButton makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(CGSizeMake(kMiniMusicPlayWidth, kMiniMusicPlayHeight));
        make.trailing.equalTo(self).offset(-8);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kMiniMusicImageWidth, kMiniMusicImageHeight));
        make.centerY.equalTo(self.centerY);
        make.left.equalTo(self.left).offset(8);
    }];
    
    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.right).offset(12);
        make.top.equalTo(self.top).offset(12);
//        make.centerY.equalTo(self.centerY);
        make.right.equalTo(self.right).offset(-60).priority(999);
    }];
    
    [self.palyButton makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kMiniMusicPlayWidth, kMiniMusicPlayHeight));
        make.right.equalTo(self.right).offset(-8);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.orderLable makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLable.leading);
        make.top.equalTo(self.titleLable.bottom).offset(8);
        make.trailing.equalTo(self.trailing).offset(-60).priority(999);
    }];
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _titleLable.text = _titleString;
}

- (void)setModel:(XJMusicList *)model{
    _model = model;
    
    self.titleString = _model.name;
    
}

- (void)setAlbum:(XJAlbumList *)album{
    _album = album;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_album.img] placeholderImage:[UIImage imageNamed:@"album_collection_background"]];
    _orderLable.text = [NSString stringWithFormat:@"当前播放专辑:%@",_album.name];
}

#pragma mark == UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}


#pragma mark == event response
- (void)tapTouch:(UITapGestureRecognizer *)tap
{

    if ([GLMusicPlayer defaultPlayer].currentTitle.length == 0) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"你还没有播放歌曲" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:action];
        
        [self.listVC presentViewController:alter animated:YES completion:^{
            
        }];
     
        return;
    }
    
//    [self hiddenView];
    
    
    GLMusicPlayViewController *playerVc;
    for (id tempVC in self.listVC.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[GLMusicPlayViewController class]]) {
            playerVc = tempVC ;
        }
    }
    [self.listVC.navigationController popToViewController:playerVc animated:YES];

}

- (void)play:(UIButton *)sender
{
    if ([GLMusicPlayer defaultPlayer].currentTitle.length == 0) {
        return;
    }
    sender.selected = !sender.selected;

    //pause对应pause
    /*
     如果流播放，则在调用暂停时暂停流播放。
     否则(流暂停)，调用暂停将继续播放。
     */
    [[GLMusicPlayer defaultPlayer] pause];
    
    if ([self.delegate respondsToSelector:@selector(miniMusicViewPaly:)]){
        [self.delegate miniMusicViewPaly:self];
    }
    
    if (!sender.selected) {
        [self pausedWithAnimated:YES];
        
    }else{
        [self playedWithAnimated:NO];
    }
}

// 播放音乐时，指针恢复，图片旋转
- (void)playedWithAnimated:(BOOL)animated {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    typeof(self) __weak weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:weakSelf selector: @selector(diskAnimation)];
        [weakSelf.displayLink invalidate];
        weakSelf.displayLink = displayLink;
    
        [weakSelf.displayLink addToRunLoop: [NSRunLoop currentRunLoop] forMode: NSDefaultRunLoopMode];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, CGFLOAT_MAX, NO);
    
    });

//    // 创建定时器
//    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(diskAnimation)];
//    // 加入到主循环中
//    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

// 暂停音乐时，指针旋转-30°，图片停止旋转
- (void)pausedWithAnimated:(BOOL)animated {
    
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}
- (void)diskAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI_4 / 100.0f);
    });
}

#pragma mark == public method

- (void)showView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(kScreenWidth, kShowBarHeight));
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.window.bottom);
        make.left.equalTo([UIApplication sharedApplication].keyWindow.window.left);
    }];
}

- (void)hiddenView
{
//    [self removeFromSuperview];
}

#pragma mark == 懒加载
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        //设置圆角 当然可以选择设置cornerRadius
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kMiniMusicImageWidth, kMiniMusicImageHeight) cornerRadius:0.0];
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = CGRectMake(0, 0, kMiniMusicImageWidth, kMiniMusicImageHeight);
        shapeLayer.path = path.CGPath;
        _imageView.layer.mask = shapeLayer;
    }
    return _imageView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textColor = HexRGB(0x565656);
        _titleLable.text = @"当前暂无歌曲~";
    }
    return _titleLable;
}

- (UILabel *)orderLable
{
    if (!_orderLable) {
        _orderLable = [[UILabel alloc] init];
        _orderLable.font = [UIFont systemFontOfSize:12];
        _orderLable.textColor = HexRGB(0x565656);
        _orderLable.text = @"当前暂无歌曲~";
    }
    return _orderLable;
}

- (UIButton *)palyButton
{
    if (!_palyButton) {
        _palyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_palyButton setImage:[UIImage imageNamed:@"mini_play_normal"] forState:UIControlStateNormal];
        [_palyButton setImage:[UIImage imageNamed:@"mini_pause_normal"] forState:UIControlStateSelected];
        [_palyButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _palyButton;
}

@end
