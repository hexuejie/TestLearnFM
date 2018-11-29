//
//  XJAlbumCollectionViewCell.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJAlbumCollectionViewCell.h"
#import "Masonry.h"
#import "public.h"
#import "UIImageView+WebCache.h"
#import "XJMusicList.h"
#import "GLMiniMusicView.h"

@implementation XJAlbumCollectionViewCell

-(instancetype)init{
    if (self = [super init]){
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

-(void)setup{
    _albumImageView = [UIImageView new];
    [self.contentView addSubview:_albumImageView];
    _albumImageView.image = [UIImage imageNamed:@"album_collection_background"];
    _albumImageView.userInteractionEnabled = NO;
    
    _volumeView = [UIImageView new];
//    _volumeView.contentMode = UIViewContentModeBottom;
    NSMutableArray *tempGifArray = [[NSMutableArray alloc]init];
    NSInteger count = 9;
    
    for (int i = 1; i<=count; i++) {
        NSString *tempWay = [NSString stringWithFormat:@"album_collection_play0%d",i];
        [tempGifArray addObject:[UIImage imageNamed:tempWay]];
    }
    
    [_volumeView setAnimationImages:tempGifArray];
    _volumeView.image = [UIImage imageNamed:@"album_collection_pause"];
    [_volumeView setAnimationDuration:0.55];
    [_volumeView setAnimationRepeatCount:0];
    [self.contentView addSubview:_volumeView];
    
    
    _tagView = [UIImageView new];
    [self.contentView addSubview:_tagView];
    _tagView.image = [UIImage imageNamed:@"album_collection_tag"];
    
    _albumLabel = [UILabel new];
    _albumLabel.font = [UIFont systemFontOfSize:14.0];
    _albumLabel.textColor = HexRGB(0x565656);
    _albumLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_albumLabel];
    
    _albumCount = [UILabel new];
    _albumCount.font = [UIFont systemFontOfSize:11.0];
    _albumCount.textColor = HexRGB(0xa0a0a0);
    _albumCount.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_albumCount];
    
    [_albumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.leading.equalTo(self.contentView).offset(12);
        make.trailing.equalTo(self.contentView).offset(-12);
        make.height.mas_equalTo(self.albumImageView.mas_width);
    }];
    
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.albumImageView);
    }];
    
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self.albumImageView);
    }];
    
    [_albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumImageView.mas_bottom).offset(2);
        make.centerX.equalTo(self.albumImageView);
    }];
    
    [_albumCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.albumLabel.mas_bottom).offset(2);
        make.centerX.equalTo(self.albumImageView);
    }];
}

- (void)setAlbum:(XJAlbumList *)album{
    _album = album;
    
    _albumLabel.text = _album.name;
    [_albumImageView sd_setImageWithURL:[NSURL URLWithString:_album.img] placeholderImage:[UIImage imageNamed:@"album_collection_background"]];
    _albumCount.text = [NSString stringWithFormat:@"-%ld首-",_album.radioAudioCount];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *radioId = [userDefaults objectForKey:@"radioId"];
    NSString *isCollection = [userDefaults objectForKey:@"isCollection"];
    //不是收藏
    if ([isCollection integerValue] == 0 && [radioId isEqualToString:_album.catalog_id]) {
        if (![GLMiniMusicView shareInstance].palyButton.selected) {
            [_volumeView stopAnimating];
            _volumeView.image = [UIImage imageNamed:@"album_collection_play01"];
        }else{
            [_volumeView startAnimating];
        }
    }else{
        [_volumeView stopAnimating];
        _volumeView.image = [UIImage imageNamed:@"album_collection_pause"];
    }
    _tagView.hidden = YES;
}

//我的收藏
- (void)setAudios:(XJAlbumMyAudios *)audios{
    _audios = audios;
    
    _albumLabel.text = _audios.name;
    [_albumImageView sd_setImageWithURL:[NSURL URLWithString:_audios.typeImg] placeholderImage:[UIImage imageNamed:@"album_collection_background"]];
    _albumCount.text = [NSString stringWithFormat:@"-%ld首-",_audios.favoriteAudios.count];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *collectionName = [userDefaults objectForKey:@"collectionName"];
    NSString *isCollection = [userDefaults objectForKey:@"isCollection"];
    
    [_volumeView stopAnimating];
    _volumeView.image = [UIImage imageNamed:@"album_collection_pause"];
    if ([isCollection integerValue] == 1 && [_audios.name isEqualToString:collectionName]) {
        
        if (![GLMiniMusicView shareInstance].palyButton.selected) {
            [_volumeView stopAnimating];
            _volumeView.image = [UIImage imageNamed:@"album_collection_play01"];
        }else{
            [_volumeView startAnimating];
        }
    }
    
    _tagView.hidden = YES;
}

@end
