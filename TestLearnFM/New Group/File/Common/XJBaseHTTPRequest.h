//
//  XJBaseHTTPRequest.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/21.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "Status.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LXObjectSuccess)(id object);
typedef void(^ESNetworkFail)(FAILCODE stateCode, NSString *error);

@interface XJBaseHTTPRequest : NSObject
- (AFHTTPSessionManager *)MJWedJsonRequestManager;

@end

NS_ASSUME_NONNULL_END
