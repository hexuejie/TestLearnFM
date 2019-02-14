//
//  XJTokenTipsView.m
//  TestLearnFM
//
//  Created by 何学杰 on 2018/12/18.
//  Copyright © 2018年 何学杰. All rights reserved.
//

#import "XJTokenTipsView.h"
#import "Masonry.h"
#import "public.h"

@implementation XJTokenTipsView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    self.bottomView = [[UIButton alloc]initWithFrame:self.bounds];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [self addSubview:self.bottomView];
    [self.bottomView addTarget:self action:@selector(bottomClick) forControlEvents:UIControlEventTouchUpInside];
//    UITapGestureRecognizer *bottpmTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomClick)];
//    [self.bottomView addGestureRecognizer:bottpmTap];
//    self.bottomView.userInteractionEnabled = YES;
//    self.userInteractionEnabled = YES;
    
    self.tipView = [[UIButton alloc]init];
    self.tipView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [self addSubview:self.tipView];
    self.tipView.userInteractionEnabled = YES;
    [self.tipView addTarget:self action:@selector(testClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tipTitleLabel = [[UILabel alloc]init];
    self.tipTitleLabel.font = [UIFont systemFontOfSize:21];//24
    self.tipTitleLabel.textColor = HexRGB(0x565656);
    [self addSubview:self.tipTitleLabel];
    
    self.tipContentLabel = [[UILabel alloc]init];
    self.tipContentLabel.font = [UIFont systemFontOfSize:14];//24
    self.tipContentLabel.textColor = HexRGB(0x565656);
    self.tipContentLabel.numberOfLines = 0;
    self.tipContentLabel.lineBreakMode = NSLineBreakByClipping;
    self.tipContentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipContentLabel];
    
    self.loginButton = [[UIButton alloc]init];
    self.loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];//24
    [self.loginButton setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [self addSubview:self.loginButton];
    self.loginButton.backgroundColor = HexRGB(0xff8d11);
    
    self.concalButton = [[UIButton alloc]init];
    self.concalButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];//24
    [self.concalButton setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    [self addSubview:self.concalButton];
    self.concalButton.backgroundColor = HexRGB(0x8dcf3f);
    
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.layer.masksToBounds = YES;
    self.concalButton.layer.cornerRadius = 10;
    self.concalButton.layer.masksToBounds = YES;
    self.tipView.layer.cornerRadius = 10;
    self.tipView.layer.masksToBounds = YES;

    [self.loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchDown];
    [self.concalButton addTarget:self action:@selector(calcanClick) forControlEvents:UIControlEventTouchDown];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self);
    }];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(290);
        make.height.mas_equalTo(160);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [self.tipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {//17
        make.top.equalTo(self.tipView).offset(17);
        make.centerX.equalTo(self);
    }];
    [self.tipContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {//17
        make.top.equalTo(self.tipTitleLabel.mas_bottom).offset(15);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {//17
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.tipView).offset(-17);
        make.leading.equalTo(self.tipView).offset(27);
    }];
    [self.concalButton mas_makeConstraints:^(MASConstraintMaker *make) {//17
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.tipView).offset(-17);
        make.trailing.equalTo(self.tipView).offset(-27);
    }];
    
    self.tipTitleLabel.text = @"系统提示";
    self.tipContentLabel.text = @"登录后即可使用歌曲收藏功能，请登录！";
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.concalButton setTitle:@"取消" forState:UIControlStateNormal];
}

- (void)bottomClick{
    if (self.concalTag == YES) {
        return;
    }
    [self removeFromSuperview];
}

- (void)calcanClick{
    [self removeFromSuperview];
}

- (void)loginClick{
    self.block();
    [self removeFromSuperview];
}


- (void)testClick{
    self.concalTag = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.concalTag = NO;
    });
}



@end
