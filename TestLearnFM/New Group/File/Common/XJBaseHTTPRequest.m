//
//  XJBaseHTTPRequest.m
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "XJBaseHTTPRequest.h"
#import "AFHTTPSessionManager.h"
#import "Utility.h"

@implementation XJBaseHTTPRequest

- (AFHTTPSessionManager *)MJWedJsonRequestManager
{
    AFHTTPSessionManager *manager =  [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.p.ajia.cn/"]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFJSONResponseSerializer *serializer =  [AFJSONResponseSerializer serializer];
    serializer.removesKeysWithNullValues = YES;
    manager.responseSerializer = serializer;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",nil];
    
    [manager.requestSerializer setValue:[[UIDevice currentDevice] systemVersion] forHTTPHeaderField:@"osv"];
    [manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"os"];

    
    
    [manager.requestSerializer setValue:@"ad75090d8de540dc985793f7529f6cd3" forHTTPHeaderField:@"auth-token"];
    manager.requestSerializer.timeoutInterval = 20.0f;
//    long long time = [Utility getCurrentDateTimeTOMilliSeconds];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",time] forHTTPHeaderField:@"timestamp"];
//    [manager.requestSerializer setValue:[Utility copyrightString:time] forHTTPHeaderField:@"access_secret"];
    
    
    
    return manager;
}


@end
