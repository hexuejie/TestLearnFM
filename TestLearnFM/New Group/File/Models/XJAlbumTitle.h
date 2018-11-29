//
//  XJAlbumTitle.h
//  LearnFM
//
//  Created by 何学杰 on 2018/10/10.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJAlbumTitle : BaseObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *albums;

+(NSDictionary *)parseDictionaryModel:(XJAlbumTitle *)model;

@end

NS_ASSUME_NONNULL_END
