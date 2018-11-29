//
//  GKWYMusicCoverView.m
//  GKWYMusic
//
//  Created by gaokun on 2018/4/20.
//  Copyright © 2018年 gaokun. All rights reserved.
//

#import "GKWYMusicCoverView.h"
#import "GKWYDiskView.h"
#import "Masonry.h"
#import "public.h"
#import "UIImageView+WebCache.h"

@interface GKWYMusicCoverView()<UIScrollViewDelegate>

//@property (nonatomic, strong) UIView            *diskBgView;

/** 唱片试图 */
@property (nonatomic, strong) GKWYDiskView      *leftDiskView;
@property (nonatomic, strong) GKWYDiskView      *centerDiskView;
@property (nonatomic, strong) GKWYDiskView      *rightDiskView;

/** 指针 */
@property (nonatomic, strong) UIImageView       *needleView;

/** 定时器 */
@property (nonatomic, strong) CADisplayLink     *displayLink;

/** 音乐列表 */
@property (nonatomic, strong) NSArray           *musics;

@property (nonatomic, assign) NSInteger         currentIndex;


/** 是否由用户点击切换歌曲 */
@property (nonatomic, assign) BOOL              isUserChanged;

@property (nonatomic, copy)   finished          finished;

@end

@implementation GKWYMusicCoverView

- (instancetype)init {
    if (self = [super init]) {
        // 超出部分裁剪
        self.clipsToBounds = YES;
        
        [self addSubview:self.diskScrollView];
        [self addSubview:self.needleView];
        self.diskScrollView.scrollEnabled = NO;
        
        [self.diskScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.isAnimation = YES;
        [self setScrollViewContentOffsetCenter];
        
//        [kNotificationCenter addObserver:self selector:@selector(networkChanged:) name:GKWYMUSIC_NETWORKCHANGENOTIFICATION object:nil];
    }
    return self;
}

- (void)networkChanged:(NSNotification *)notify {
    self.currentIndex = self.currentIndex;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self pausedWithAnimated:NO];
    
    CGFloat diskW = CGRectGetWidth(self.diskScrollView.frame);
    CGFloat diskH = CGRectGetHeight(self.diskScrollView.frame);
    
    // 设置frame
    self.leftDiskView.frame     = CGRectMake(0, 0, diskW, diskH);
    self.centerDiskView.frame   = CGRectMake(diskW, 0, diskW, diskH);
    self.rightDiskView.frame    = CGRectMake(2 * diskW, 0, diskW, diskH);
    

}

#pragma mark - Public Methods
- (void)initMusicList:(NSArray *)musics idx:(NSInteger)currentIndex {
    [self resetCoverView];
    
    self.musics = musics;
    
    [self setCurrentIndex:currentIndex needChange:YES];
}

- (void)resetMusicList:(NSArray *)musics idx:(NSInteger)currentIndex {
    self.musics = musics;
    
    [self setCurrentIndex:currentIndex needChange:NO];
}

// 滑动切换歌曲
- (void)scrollChangeDiskIsNext:(BOOL)isNext finished:(finished)finished {
    self.isUserChanged = YES;
    
    self.finished = finished;
    
    CGFloat pointX = isNext ? 2 * ScreenWidth : 0;
    CGPoint offset = CGPointMake(pointX, 0);
    
    [self pausedWithAnimated:YES];
    
    BOOL isBackground = [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
    
    if (isBackground) {
        // 这里处理是因为在后台锁屏状态下，改变scrollView不走结束方法，所以强制切换歌曲
        [self.diskScrollView setContentOffset:offset animated:NO];
        [self scrollViewDidEnd:self.diskScrollView];
    }else {
        [self.diskScrollView setContentOffset:offset animated:YES];
    }
}

// 播放音乐时，指针恢复，图片旋转
- (void)playedWithAnimated:(BOOL)animated {
    if (self.isAnimation) return;
    self.isAnimation = YES;
    
    [self setAnchorPoint:CGPointMake(25.0f / 97.0f, 25.0f / 153.0f) forView:self.needleView];
    
    if (animated) {
        [UIView animateWithDuration:0.5f animations:^{
            self.needleView.transform = CGAffineTransformIdentity;
        }];
    }else {
        self.needleView.transform = CGAffineTransformIdentity;
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
////    NSLog(@"旋转定时器创建成功");
}

// 暂停音乐时，指针旋转-30°，图片停止旋转
- (void)pausedWithAnimated:(BOOL)animated {
    if (!self.isAnimation) return;
    self.isAnimation = NO;
    
    [self setAnchorPoint:CGPointMake(25.0f / 97.0f, 25.0f / 153.0f) forView:self.needleView];
    
    if (animated) {
        [UIView animateWithDuration:0.5f animations:^{
            self.needleView.transform = CGAffineTransformMakeRotation(-M_PI_2 / 3);
        }];
    }else {
        self.needleView.transform = CGAffineTransformMakeRotation(-M_PI_2 / 3);
    }
    
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)resetCoverView {
//    if (self.displayLink) {
//        [self.displayLink invalidate];
//        self.displayLink = nil;
//    }
}

- (void)diskAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.centerDiskView.diskImgView.transform = CGAffineTransformRotate(self.centerDiskView.diskImgView.transform, M_PI_4 / 100.0f);
    });
    
}

- (void)nextMusicAnimate{
    CGFloat diskW = CGRectGetWidth(self.diskScrollView.frame);
    CGFloat diskH = CGRectGetHeight(self.diskScrollView.frame);
    self.leftDiskView.frame = CGRectMake(-diskW, 0, diskW, diskH);
    self.centerDiskView.frame  = CGRectMake(diskW, 0, diskW, diskH);
    self.leftDiskView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.leftDiskView.diskImgView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"album_collection_background"]];
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.leftDiskView.frame = weakSelf.centerDiskView.frame;
        weakSelf.centerDiskView.frame = CGRectMake(diskW*2, 0, diskW, diskH);
    } completion:^(BOOL finished) {
        weakSelf.centerDiskView.frame = CGRectMake(diskW, 0, diskW, diskH);
        weakSelf.centerDiskView.diskImgView.transform = CGAffineTransformIdentity;
        weakSelf.leftDiskView.hidden = YES;
        
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.position"];
//        animation.values =  @[@(0.1),@(1.0),@(1.5)];
//        //    animation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
//        animation.calculationMode = kCAAnimationLinear;
//        //    animation.isAdditive = true;
//        animation.repeatCount = 3;
//        animation.duration = 0.5;
//        animation.keyPath = @"position";
//
//        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(diskW+2, 0, diskW, diskH)];
//        animation.path = bezierPath.CGPath;
////        UIBezierPath(ovalIn: CGRect(x: 20, y: 200, width: diskW, height: diskH)).cgPath;
//
//        [weakSelf.centerDiskView.layer addAnimation:animation forKey:@"position"];
//
//
//        /*
//         kCAAnimationLinear     :   默认差值
//         kCAAnimationDiscrete   :   逐帧显示
//         kCAAnimationPaced      :   匀速 无视keyTimes
//         kCAAnimationCubic      :   keyValue之间曲线平滑 可用 tensionValues,continuityValues,biasValues 调整
//         kCAAnimationCubicPaced :   keyValue之间平滑差值 无视keyTimes
//         */
//        animation.calculationMode = kCAAnimationPaced; //无视keytimes
//        /*
//         kCAAnimationRotateAuto         :   自动
//         kCAAnimationRotateAutoReverse  :   自动翻转
//         不设置则不旋转
//         */
//        animation.rotationMode = kCAAnimationRotateAuto;
        [weakSelf playedWithAnimated:YES];
    }];
    
}

- (void)frontMusicAnimate{
    CGFloat diskW = CGRectGetWidth(self.diskScrollView.frame);
    CGFloat diskH = CGRectGetHeight(self.diskScrollView.frame);
    self.leftDiskView.frame = CGRectMake(diskW*3, 0, diskW, diskH);
    self.centerDiskView.frame  = CGRectMake(diskW, 0, diskW, diskH);
    self.leftDiskView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [self.leftDiskView.diskImgView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"album_collection_background"]];
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.leftDiskView.frame = weakSelf.centerDiskView.frame;
        weakSelf.centerDiskView.frame = CGRectMake(-diskW, 0, diskW, diskH);
    } completion:^(BOOL finished) {
        weakSelf.centerDiskView.frame = CGRectMake(diskW, 0, diskW, diskH);
        weakSelf.centerDiskView.diskImgView.transform = CGAffineTransformIdentity;
        weakSelf.leftDiskView.hidden = YES;
        [weakSelf playedWithAnimated:YES];
    }];
}

#pragma mark - Private Methods
- (void)setImageURL:(NSString *)imageURL{
    _imageURL = imageURL;
    [self.centerDiskView.diskImgView sd_setImageWithURL:[NSURL URLWithString:_imageURL] placeholderImage:[UIImage imageNamed:@"album_collection_background"]];
}

- (void)setCurrentIndex:(NSInteger)currentIndex needChange:(BOOL)needChange {
    if (currentIndex >= 0) {
        self.currentIndex = currentIndex;
        
        NSInteger count         = self.musics.count;
        NSInteger leftIndex     = (currentIndex + count - 1) % count;
        NSInteger rightIndex    = (currentIndex + 1) % count;
        
        GKWYMusicModel *leftM   = self.musics[leftIndex];
        GKWYMusicModel *centerM = self.musics[currentIndex];
        GKWYMusicModel *rightM  = self.musics[rightIndex];
        
        // 设置图片
        self.centerDiskView.imgUrl = centerM.pic_radio;
        
        if (needChange) {
            self.centerDiskView.diskImgView.transform = CGAffineTransformIdentity;
            
            // 每次设置后，移到中间
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self setScrollViewContentOffsetCenter];
                
                self.leftDiskView.imgUrl    = leftM.pic_radio;
                self.rightDiskView.imgUrl   = rightM.pic_radio;
                
                if (self.isUserChanged) {
                    !self.finished ? : self.finished();
                    self.isUserChanged = NO;
                }
            });
        }else {
            self.leftDiskView.imgUrl    = leftM.pic_radio;
            self.rightDiskView.imgUrl   = rightM.pic_radio;
        }
    }
}

- (void)setScrollViewContentOffsetCenter {
    [self.diskScrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
}

// 设置试图的锚点
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake(view.center.x - transition.x, view.center.y - transition.y);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollW = CGRectGetWidth(scrollView.frame);
    if (scrollW == 0) return;
    // 滑动超过一半时
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX <= 0.5 * scrollW) { // 左滑
        NSInteger idx = (self.currentIndex - 1 + self.musics.count) % self.musics.count;
        
        if ([self.delegate respondsToSelector:@selector(scrollWillChangeModel:)]) {
            [self.delegate scrollWillChangeModel:self.musics[idx]];
        }
    }else if (offsetX >= 1.5 * scrollW) { // 右滑
        NSInteger idx = (self.currentIndex + 1) % self.musics.count;
        
        if ([self.delegate respondsToSelector:@selector(scrollWillChangeModel:)]) {
            [self.delegate scrollWillChangeModel:self.musics[idx]];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self pausedWithAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(scrollDidScroll)]) {
        [self.delegate scrollDidScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEnd:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEnd:scrollView];
}

- (void)scrollViewDidEnd:(UIScrollView *)scrollView {
    // 滑动结束时，获取索引
    CGFloat scrollW = CGRectGetWidth(scrollView.frame);
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX == 2 * scrollW) {
        NSInteger currentIndex = (self.currentIndex + 1) % self.musics.count;
        
        [self setCurrentIndex:currentIndex needChange:YES];
    }else if (offsetX == 0) {
        NSInteger currentIndex = (self.currentIndex - 1 + self.musics.count) % self.musics.count;
        
        [self setCurrentIndex:currentIndex needChange:YES];
    }else {
        [self setScrollViewContentOffsetCenter];
    }
    
    GKWYMusicModel *model = self.musics[self.currentIndex];
    
    if ([self.delegate respondsToSelector:@selector(scrollDidChangeModel:)]) {
        [self.delegate scrollDidChangeModel:model];
    }
}

#pragma mark - 懒加载
//- (UIView *)diskBgView {
//    if (!_diskBgView) {
//        _diskBgView = [UIView new];
//        _diskBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
//        
//        _diskBgView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
//        _diskBgView.layer.borderWidth = 10.0f;
//        _diskBgView.layer.cornerRadius = (ScreenWidth - 75.0f) * 0.5;
//    }
//    return _diskBgView;
//}

- (UIScrollView *)diskScrollView {
    if (!_diskScrollView) {
        _diskScrollView = [UIScrollView new];
        _diskScrollView.delegate        = self;
        _diskScrollView.pagingEnabled   = YES;
        _diskScrollView.backgroundColor = [UIColor clearColor];
        _diskScrollView.showsHorizontalScrollIndicator = NO;
        
        [_diskScrollView addSubview:self.leftDiskView];
        [_diskScrollView addSubview:self.centerDiskView];
//        [_diskScrollView addSubview:self.rightDiskView];
        _diskScrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    }
    return _diskScrollView;
}

- (GKWYDiskView *)leftDiskView {
    if (!_leftDiskView) {
        _leftDiskView = [GKWYDiskView new];
    }
    return _leftDiskView;
}

- (GKWYDiskView *)centerDiskView {
    if (!_centerDiskView) {
        _centerDiskView = [GKWYDiskView new];
    }
    return _centerDiskView;
}

- (GKWYDiskView *)rightDiskView {
    if (!_rightDiskView) {
        _rightDiskView = [GKWYDiskView new];
    }
    return _rightDiskView;
}

- (UIImageView *)needleView {
    if (!_needleView) {
        _needleView = [UIImageView new];
        _needleView.image = [UIImage imageNamed:@"cm2_play_needle_play"];
        [_needleView sizeToFit];
    }
    return _needleView;
}

@end
