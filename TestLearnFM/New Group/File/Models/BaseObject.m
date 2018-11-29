//
//  BaseObject.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseObject.h"


@implementation BaseObject


- (id) proxyForJson
{
    return nil;
}

+(id)mockObj{
    return nil;
}

+(NSArray *)mockArray:(NSUInteger)number{
    return nil;
}

+(id)parseDic:(NSDictionary *)dic{
    return nil;
}
+(NSArray *)parseArrayDic:(NSDictionary *)dic{
    return nil;
}


@end
