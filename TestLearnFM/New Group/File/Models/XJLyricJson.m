//
//  XJLyricJson.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJLyricJson.h"

@implementation XJLyricJson

+(id)parseDic:(NSDictionary *)dic{
    
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    XJLyricJson *model = [XJLyricJson new];
    
    model.msTime = [dic[@"time"] integerValue]/1000;
    model.content = dic[@"info"];

    return model;
}


+(NSArray *)parseArrayDic:(NSArray *)array{
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [result addObject:[XJLyricJson parseDic:obj]];
    }];
    
    return result;
    
}

@end
