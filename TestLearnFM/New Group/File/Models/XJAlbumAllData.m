//
//  XJAlbumAllData.m
//  LearnFM
//
//  Created by 何学杰 on 2018/10/11.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJAlbumAllData.h"
#import "XJAlbumTitle.h"
#import "XJAlbumMyAudios.h"

@implementation XJAlbumAllData

+(id)parseDic:(NSDictionary *)dic{
    
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    XJAlbumAllData *model = [XJAlbumAllData new];
    
    model.myAudios = [XJAlbumMyAudios parseArrayDic:dic[@"myAudios"]];
    model.list = [XJAlbumTitle parseArrayDic:dic[@"list"]];
    
    return model;
}

+(NSDictionary *)parseDictionaryModel:(XJAlbumAllData *)model{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *tempAddmyAudios = [NSMutableArray array];
    for (XJAlbumMyAudios *tempmyAudios in model.myAudios) {
        [tempAddmyAudios addObject:[XJAlbumMyAudios parseDictionaryModel:tempmyAudios]];
    }
    [dic setValue:tempAddmyAudios forKey:@"myAudios"];
    
    
    NSMutableArray *tempAddList = [NSMutableArray array];
    for (XJAlbumTitle *tempList in model.list) {
        [tempAddList addObject:[XJAlbumTitle parseDictionaryModel:tempList]];
    }
    [dic setValue:tempAddList forKey:@"list"];
  
    return dic;
}

+(NSArray *)parseArrayDic:(NSArray *)array{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [result addObject:[XJAlbumAllData parseDic:obj]];
    }];
    
    return result;
    
}

@end
