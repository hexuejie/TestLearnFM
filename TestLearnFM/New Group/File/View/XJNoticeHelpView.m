//
//  XJNoticeHelpView.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/26.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//
#import "public.h"
#import "XJNoticeHelpView.h"

@implementation XJNoticeHelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView
{
//    [super awakeFromNib];
    _midLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-60, ScreenHeight/2-25, 120, 50)];
    [self addSubview:_midLabel];
    _midLabel.font = [UIFont systemFontOfSize:15];
    _midLabel.textColor = [UIColor whiteColor];
    _midLabel.text = @"顺序播放";
    _midLabel.textAlignment = NSTextAlignmentCenter;
    _midLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    _midLabel.layer.cornerRadius = 7.0;
    _midLabel.layer.masksToBounds = YES;
    _midLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.55];
    
    
    _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addSubview:_maskView];
}

- (void)showNotice{

    self.alpha = 1.0;
    self.midLabel.hidden = NO;
    self.midLabel.alpha = 1.0;
    self.superview.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.midLabel.alpha = 0.0;
        self.alpha = 0.0;
        self.superview.userInteractionEnabled = YES;
    });
    
}

@end
