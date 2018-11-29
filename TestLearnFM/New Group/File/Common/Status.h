//
//  Status.h
//  eShop
//
//  Created by Kyle on 14-10-16.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FAILCODE)
{
    NetFail = 1,
    ParamentError = 2,
    NetSuccess = 0,
    UerForbid = 304,
    NetError = 400,
    UserExpried = 406
};

@interface Status : NSObject

@property (nonatomic, assign) BOOL status;
@property (nonatomic, assign) FAILCODE code;
@property (nonatomic, copy) NSString *msg;

+(instancetype)shareStatus;
+(instancetype)parseDictionary:(NSDictionary *)dic;


- (id) proxyForJson;

+(id)mockObj;
+(NSArray *)mockArray:(NSUInteger)number;

+(id)parseDic:(NSDictionary *)dic;
+(NSArray *)parseArrayDic:(NSArray *)array;
@end
