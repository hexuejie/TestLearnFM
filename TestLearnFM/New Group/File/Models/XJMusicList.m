//
//  XJMusicList.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/25.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJMusicList.h"
#import "XJLyricJson.h"

@implementation XJMusicList


+(id)parseDic:(NSDictionary *)dic{
    
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    XJMusicList *model = [XJMusicList new];
    
    model.isPlay = NO;
    model.isCollection = NO;
    model.music_id = dic[@"id"];
    model.createTime = dic[@"createTime"];
    
    model.status = [dic[@"status"] integerValue];
    model.name = dic[@"name"];
    model.radioId = dic[@"radioId"];
    
    model.playTime = dic[@"playTime"];
    model.audioUrl = dic[@"audioUrl"];
    model.lyricUrl = dic[@"lyricUrl"];
    model.lyricJsonArray = [XJLyricJson parseArrayDic:dic[@"lyricJson"][@"list"]];
    model.hasFavorite = [dic[@"hasFavorite"] boolValue];
//    lyricJson
    
    model.shareMsg = dic[@"shareMsg"];
    model.orderNum = [dic[@"orderNum"] integerValue];
    
    model.isPlay = [dic[@"isPlay"] boolValue];
    model.isCollection = [dic[@"isCollection"] boolValue];
    return model;
}

+(NSDictionary *)parseDictionaryModel:(XJMusicList *)model{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:model.music_id forKey:@"id"];
    [dic setValue:model.createTime forKey:@"createTime"];
    
    [dic setValue:[NSNumber numberWithInteger:model.status] forKey:@"status"];
    [dic setValue:model.name forKey:@"name"];
    [dic setValue:model.radioId forKey:@"radioId"];
    
    [dic setValue:model.playTime forKey:@"playTime"];
    [dic setValue:model.audioUrl forKey:@"audioUrl"];
    [dic setValue:model.lyricUrl forKey:@"lyricUrl"];
    [dic setValue:[NSNumber numberWithInteger:model.hasFavorite] forKey:@"hasFavorite"];
    
    [dic setValue:model.shareMsg forKey:@"shareMsg"];
    [dic setValue:[NSNumber numberWithInteger:model.orderNum] forKey:@"orderNum"];
    [dic setValue:[NSNumber numberWithInteger:model.isPlay] forKey:@"isPlay"];
    [dic setValue:[NSNumber numberWithInteger:model.isCollection] forKey:@"isCollection"];
    
    NSMutableArray *tempList = [[NSMutableArray alloc]init];
    for (XJLyricJson *lyricJson in model.lyricJsonArray) {
        NSDictionary *tempLyricJson = @{@"time":[NSNumber numberWithInteger:lyricJson.msTime*1000],
                                        @"info":lyricJson.content
                                        };
        [tempList addObject:tempLyricJson];
    }
    NSDictionary *tempDic = @{@"list":tempList};
    [dic setValue:tempDic forKey:@"lyricJson"];
    return dic;
}

+(NSArray *)parseArrayDic:(NSArray *)array{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [result addObject:[XJMusicList parseDic:obj]];
    }];
    
    return result;
    
}



@end
