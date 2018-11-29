//
//  XJMusicTableViewCell.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJMusicTableViewCell.h"
#import "public.h"
#import "Masonry.h"
#import "GLMiniMusicView.h"

@implementation XJMusicTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setup];
    }
    return self;
}


-(void)setup{
    
    self.backgroundColor = HexRGB(0xf0f0f3);
    self.contentView.backgroundColor = HexRGB(0xf0f0f3);
    _maskView = [UIView new];
    _maskView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_maskView];
    
    _musicTitle = [UILabel new];
    _musicTitle.font = [UIFont systemFontOfSize:15];
    _musicTitle.textColor = HexRGB(0x565656);
    _musicTitle.textAlignment = NSTextAlignmentLeft;
    [_maskView addSubview:_musicTitle];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = HexRGB(0xf0f0f3);
    [_maskView addSubview:_lineView];
    
    _volumeView = [UIImageView new];
    _volumeView.contentMode = UIViewContentModeBottom;
    NSMutableArray *tempGifArray = [[NSMutableArray alloc]init];
    NSInteger count = 9;
    
    for (int i = 1; i<=count; i++) {
        NSString *tempWay = [NSString stringWithFormat:@"music0%d",i];
        [tempGifArray addObject:[UIImage imageNamed:tempWay]];
    }

    [_volumeView setAnimationImages:tempGifArray];
    _volumeView.image = [UIImage imageNamed:@"music01"];
    [_volumeView setAnimationDuration:0.55];
    [_volumeView setAnimationRepeatCount:0];
    [_maskView addSubview:_volumeView];
    
    [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(0);//8
        make.top.bottom.equalTo(self.contentView).offset(0);
        make.trailing.equalTo(self.contentView).offset(-0);//8
    }];
    
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView);
        make.trailing.equalTo(self.maskView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(46*0.6, 32*0.6));
    }];
    [_musicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView);
        make.leading.equalTo(self.maskView).offset(10);
        make.trailing.equalTo(self.volumeView.mas_leading).offset(-10);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.leading.bottom.trailing.equalTo(self.maskView);
    }];
}

- (void)setModel:(XJMusicList *)model{
    _model = model;
    
//    _volumeView.hidden = !_model.isPlay;
    _musicTitle.text = _model.name;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *music_id = [userDefaults objectForKey:@"music_id"];
    if (music_id != nil && [music_id isEqualToString:_model.music_id]) {
        _volumeView.hidden = NO;
        _musicTitle.textColor = HexRGB(0x89c35d);
        if (![GLMiniMusicView shareInstance].palyButton.selected) {
            [_volumeView stopAnimating];
        }else{
            [_volumeView startAnimating];
        }
        
    }else{
        _musicTitle.textColor = HexRGB(0x565656);
        _volumeView.hidden = YES;
        [_volumeView stopAnimating];
    }
}


@end
