//
//  XJAlbumCollectionViewCell.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJAlbumList.h"
#import "XJAlbumMyAudios.h"

@interface XJAlbumCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *volumeView;
@property (nonatomic, strong) UIImageView *tagView;

@property (nonatomic, strong) UILabel *albumLabel;
@property (nonatomic, strong) UILabel *albumCount;
@property (nonatomic, strong) UIImageView *albumImageView;


@property (nonatomic, strong) XJAlbumList *album;
@property (nonatomic, strong) XJAlbumMyAudios *audios;

@end

