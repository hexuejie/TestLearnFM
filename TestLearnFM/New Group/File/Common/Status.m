//
//  Status.m
//  eShop
//
//  Created by Kyle on 14-10-16.
//  Copyright (c) 2014年 yujiahui. All rights reserved.
//

#import "Status.h"

#define kCode @"error"
#define kMsg @"message"


@implementation Status

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Status code:%ld, msg:%@]",self.code,self.msg];
}

+(instancetype)shareStatus
{
    Status *status = [[Status alloc] init];
    status.status = FALSE;
    status.code = NetFail;
    status.msg = @"";
    return status;
}

+(instancetype)parseDictionary:(NSDictionary *)dic
{
    Status *status = [Status shareStatus];
    if ([dic isKindOfClass:[NSNull class]]) {
        status.status = 1;
    }else{
        status.status = [[dic objectForKey:kCode] integerValue] == NetSuccess ? TRUE:FALSE;
        status.code = [[dic objectForKey:kCode] integerValue];
        status.msg = [dic objectForKey:kMsg];
    }
    
    return status;
}




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
