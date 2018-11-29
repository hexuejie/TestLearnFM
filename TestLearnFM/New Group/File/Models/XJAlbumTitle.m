//
//  XJAlbumTitle.m
//  LearnFM
//
//  Created by 何学杰 on 2018/10/10.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJAlbumTitle.h"
#import "XJAlbumList.h"

@implementation XJAlbumTitle

+(id)parseDic:(NSDictionary *)dic{
    
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    XJAlbumTitle *model = [XJAlbumTitle new];
    
    model.name = dic[@"name"];
    model.albums = [XJAlbumList parseArrayDic:dic[@"radioAudios"]];
    
    return model;
}

+(NSDictionary *)parseDictionaryModel:(XJAlbumTitle *)model{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:model.name forKey:@"name"];
    
    NSMutableArray *tempAddAlbum = [NSMutableArray array];
    for (XJAlbumList *tempAlbum in model.albums) {
        [tempAddAlbum addObject:[XJAlbumList parseDictionaryModel:tempAlbum]];
    }
    [dic setValue:tempAddAlbum forKey:@"radioAudios"];
    
    return dic;
}



+(NSArray *)parseArrayDic:(NSArray *)array{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [result addObject:[XJAlbumTitle parseDic:obj]];
    }];
    
    return result;
    
}

@end
