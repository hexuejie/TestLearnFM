//
//  XJAlbumMyAudios.h
//  LearnFM
//
//  Created by 何学杰 on 2018/10/11.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseObject.h"

@interface XJAlbumMyAudios : BaseObject


@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *typeImg;
@property (nonatomic,copy) NSArray *favoriteAudios;

+(NSDictionary *)parseDictionaryModel:(XJAlbumMyAudios *)model;
@end

