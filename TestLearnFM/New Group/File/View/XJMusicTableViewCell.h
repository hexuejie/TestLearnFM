//
//  XJMusicTableViewCell.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJMusicList.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJMusicTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *musicTitle;
@property (nonatomic, strong) UIImageView *volumeView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) XJMusicList *model;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL isFirst;
@end

NS_ASSUME_NONNULL_END
