//
//  LXToolsHTTPRequest.h
//  lexiwed2
//
//  Created by Kyle on 2017/7/20.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "XJBaseHTTPRequest.h"


@interface LXToolsHTTPRequest : XJBaseHTTPRequest

- (void)albumRequestSuccess:(LXObjectSuccess)success fail:(ESNetworkFail)fail;
- (id)albumGetLocalData;
- (id)musicGetLocalDataRadioId:(NSString *)radioId;

- (void)writeToFileArray:(id )array byAppendingPath:(NSString *)appendingPath;

- (void)musicListRequestRadioId:(NSString *)radioId Success:(LXObjectSuccess)success fail:(ESNetworkFail)fail;


- (void)musicDeleteCollectionRequestMusicId:(NSString *)musicId Success:(LXObjectSuccess)success fail:(ESNetworkFail)fail;
- (void)musicCollectionRequestMusicId:(NSString *)musicId Success:(LXObjectSuccess)success fail:(ESNetworkFail)fail;
@end
