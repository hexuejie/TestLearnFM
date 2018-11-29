//
//  BaseObject.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseObject : NSObject

- (id) proxyForJson;

+(id)mockObj;
+(NSArray *)mockArray:(NSUInteger)number;

+(id)parseDic:(NSDictionary *)dic;
+(NSArray *)parseArrayDic:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
