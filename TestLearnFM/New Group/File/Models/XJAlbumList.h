//
//  XJAlbumList.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJAlbumList : BaseObject

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *catalog_id;
@property (nonatomic, assign) NSInteger radioAudioCount;

+(NSDictionary *)parseDictionaryModel:(XJAlbumList *)model;
@end

NS_ASSUME_NONNULL_END
