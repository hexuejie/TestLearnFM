//
//  XJAlbumAllData.h
//  LearnFM
//
//  Created by 何学杰 on 2018/10/11.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJAlbumAllData : BaseObject

@property (nonatomic,copy) NSArray *myAudios;//收藏的
@property (nonatomic,copy) NSArray *list;

+(NSDictionary *)parseDictionaryModel:(XJAlbumAllData *)model;
@end

NS_ASSUME_NONNULL_END
