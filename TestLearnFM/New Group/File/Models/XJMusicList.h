//
//  XJMusicList.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseObject.h"

@class XJLyricJson;
NS_ASSUME_NONNULL_BEGIN

@interface XJMusicList : BaseObject

@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) BOOL isCollection;

@property (nonatomic, copy) NSString *music_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL hasFavorite;

@property (nonatomic, copy) NSString *collectionName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *radioId;
@property (nonatomic, copy) NSString *playTime;

@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, copy) NSString *lyricUrl;
@property (nonatomic, copy) NSArray <XJLyricJson*>*lyricJsonArray;

@property (nonatomic, copy) NSString *shareMsg;
@property (nonatomic, assign) NSInteger orderNum;

+(NSDictionary *)parseDictionaryModel:(XJMusicList *)model;

@end

//"id":"f8fa2c5f-4f3f-4009-8f3e-4c76e79df275",
//"createTime":1529483081382,
//"status":0,
//"name":"自然景象： 大海 Sea 水蓝蓝",
//"radioId":"a475b22b-bd23-418c-99c9-fb0ac37c7262",
//"playTime":"2:39",
//"audioUrl":"https://ajiau.oss-cn-shenzhen.aliyuncs.com/radio/2018/0620/152948305043166.mp3",
//"lyricUrl":"https://ajiau.oss-cn-shenzhen.aliyuncs.com/radio/2018/0620/152948306650067.json",
//"shareMsg":"自然景象： 大海 Sea 水蓝蓝",
//"orderNum":999

NS_ASSUME_NONNULL_END
