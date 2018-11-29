//
//  XJAlbumList.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJAlbumList.h"
#import "XJLyricJson.h"

@implementation XJAlbumList

+(id)parseDic:(NSDictionary *)dic{
    
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    XJAlbumList *model = [XJAlbumList new];
    model.name = dic[@"name"];
    model.img = dic[@"img"];;
    model.catalog_id = dic[@"id"];
    model.radioAudioCount = [dic[@"radioAudioCount"] integerValue];
    
    model.isPlay = NO;
    return model;
}

+(NSDictionary *)parseDictionaryModel:(XJAlbumList *)model{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:model.name forKey:@"name"];
    [dic setValue:model.img forKey:@"img"];
    [dic setValue:model.catalog_id forKey:@"id"];
    [dic setValue:[NSNumber numberWithInteger:model.radioAudioCount] forKey:@"radioAudioCount"];
    
    return dic;
}


+(NSArray *)parseArrayDic:(NSArray *)array{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [result addObject:[XJAlbumList parseDic:obj]];
    }];
    
    return result;
    
}



@end
