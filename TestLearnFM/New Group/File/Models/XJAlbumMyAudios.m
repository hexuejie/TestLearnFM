//
//  XJAlbumMyAudios.m
//  LearnFM
//
//  Created by 何学杰 on 2018/10/11.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJAlbumMyAudios.h"
#import "XJAlbumList.h"
#import "XJMusicList.h"

@implementation XJAlbumMyAudios

+(id)parseDic:(NSDictionary *)dic{
    
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    XJAlbumMyAudios *model = [XJAlbumMyAudios new];
    
    model.typeImg = dic[@"typeImg"];
    model.name = dic[@"name"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id temp in dic[@"favoriteAudios"]) {
        XJMusicList *music = [XJMusicList parseDic:temp];
        music.isCollection = YES;
        music.hasFavorite = YES;
        music.collectionName = model.name;
        [tempArray addObject:music];
    }
    model.favoriteAudios = tempArray;//[XJMusicList parseArrayDic:dic[@"favoriteAudios"]];
    
    return model;
}

+(NSDictionary *)parseDictionaryModel:(XJAlbumMyAudios *)model{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setValue:model.name forKey:@"name"];
    [dic setValue:model.typeImg forKey:@"typeImg"];
    
    
    NSMutableArray *tempAddAudios = [NSMutableArray array];
    for (XJMusicList *tempList in model.favoriteAudios) {
        [tempAddAudios addObject:[XJMusicList parseDictionaryModel:tempList]];
    }
    [dic setValue:tempAddAudios forKey:@"favoriteAudios"];
    
    return dic;
}

+(NSArray *)parseArrayDic:(NSArray *)array{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [result addObject:[XJAlbumMyAudios parseDic:obj]];
    }];
    
    return result;
    
}

@end
