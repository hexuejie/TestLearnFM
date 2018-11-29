//
//  LXToolsHTTPRequest.m
//  lexiwed2
//
//  Created by Kyle on 2017/7/20.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "LXToolsHTTPRequest.h"
#import "XJAlbumList.h"
#import "XJMusicList.h"
#import "public.h"
#import "XJAlbumTitle.h"
#import "XJAlbumAllData.h"
#import "GLMusicPlayer.h"

@implementation LXToolsHTTPRequest
{
    NSURLSessionDataTask *_albumInstance;
    NSString *baseApi;
}



- (void)idCheck{
    if ([GLMusicPlayer defaultPlayer].authToken == nil) {
        [GLMusicPlayer defaultPlayer].authToken = AuthToken;
    }
    if ([GLMusicPlayer defaultPlayer].studentid == nil) {
        [GLMusicPlayer defaultPlayer].studentid = Studentid;
    }
    if ([GLMusicPlayer defaultPlayer].requestFM == nil) {
        baseApi = [NSString stringWithFormat:@"%@%@",KRequestFM,KRequestSingle];
    }else{
        baseApi = [NSString stringWithFormat:@"%@%@",[GLMusicPlayer defaultPlayer].requestFM,KRequestSingle];
    }
}

- (void)albumRequestSuccess:(LXObjectSuccess)success fail:(ESNetworkFail)fail{
    [self idCheck];
    
    NSString *parame = [NSString stringWithFormat:@"{\"functionName\":\"QueryRadioList\",\"parameters\":{\"studentId\":[\"%@\"],\"getMyFavorite\":[\"true\"]}}",[GLMusicPlayer defaultPlayer].studentid];
    NSData * body = [parame dataUsingEncoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:baseApi parameters:nil error:nil];
    request.timeoutInterval= 6.0f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[GLMusicPlayer defaultPlayer].authToken forHTTPHeaderField:@"auth-token"];
    [request setValue:[GLMusicPlayer defaultPlayer].studentid forHTTPHeaderField:@"studentid"];
    [request setValue:@"true" forHTTPHeaderField:@"getMyFavorite"];
    // 设置body
    [request setHTTPBody:body];
    
    __weak typeof(self) weakSelf = self;
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    
        if (!error) {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject[@"data"];
            if ([responseDictionary isKindOfClass:[NSNull class]]) {
                fail(1,@"无数据");
                return ;
            }
            Status *status = [Status parseDictionary:responseDictionary];
            if (!status.status || responseDictionary.count == 0) {
                fail(status.code,status.msg);
                return;
            }
            XJAlbumAllData *tasks = [XJAlbumAllData parseDic:responseDictionary];
            [weakSelf writeToFileArray:responseDictionary byAppendingPath:kAlbumFile];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(tasks);
                });
            });
        } else {
//            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil];
//            [alter show];
            fail(NetError,[error localizedDescription]);
        }
    }] resume];
}

- (void)writeToFileArray:(id )array byAppendingPath:(NSString *)appendingPath{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:appendingPath];
    [array writeToFile:filePath atomically:YES];
}

- (id)albumGetLocalData{//本地数据
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:kAlbumFile];
//    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
    NSArray *tasks = [XJAlbumAllData parseDic:tempDic];
    return tasks;
}

- (id)musicGetLocalDataRadioId:(NSString *)radioId{//本地数据
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appending = [NSString stringWithFormat:@"%@%@",radioId,kMusicFile];
    NSString *filePath = [docPath stringByAppendingPathComponent:appending];
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithContentsOfFile:filePath];
    NSArray *tasks = [XJMusicList parseArrayDic:tempArray];
    return tasks;
}

- (void)musicListRequestRadioId:(NSString *)radioId Success:(LXObjectSuccess)success fail:(ESNetworkFail)fail{
    [self idCheck];
    NSString *parame = [NSString stringWithFormat:@"{\"functionName\":\"QueryRadioAudioList\",\"parameters\":{\"radioId\":[\"%@\"]}}",radioId] ;
    NSData * body = [parame dataUsingEncoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:baseApi parameters:nil error:nil];
    request.timeoutInterval= 6.0f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[GLMusicPlayer defaultPlayer].authToken forHTTPHeaderField:@"auth-token"];
    [request setValue:[GLMusicPlayer defaultPlayer].studentid forHTTPHeaderField:@"studentid"];
    // 设置body
    [request setHTTPBody:body];
    
    __weak typeof(self) weakSelf = self;
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject[@"data"];
            if ([responseDictionary isKindOfClass:[NSNull class]]) {
                fail(1,@"无数据");
                return ;
            }
            Status *status = [Status parseDictionary:responseDictionary];
            if (!status.status) {
                fail(status.code,status.msg);
                return;
            }
            NSArray *tasks = [XJMusicList parseArrayDic:[responseDictionary objectForKey:@"radioAudios"]];
            
            NSString *filePath = [NSString stringWithFormat:@"%@%@",radioId,kMusicFile];
            [weakSelf writeToFileArray:[responseDictionary objectForKey:@"radioAudios"] byAppendingPath:filePath];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(tasks);
                });
            });
        } else {
            fail(NetError,[error localizedDescription]);
        }
    }] resume];
}

//StudentDeleteAudioFromFavorite
- (void)musicCollectionRequestMusicId:(NSString *)musicId Success:(LXObjectSuccess)success fail:(ESNetworkFail)fail{
    [self idCheck];
    NSString *parame = [NSString stringWithFormat:@"{\"functionName\":\"StudentAddAudioToFavorite\",\"parameters\":{\"audioId\":[\"%@\"]}}",musicId] ;
    NSData * body = [parame dataUsingEncoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:baseApi parameters:nil error:nil];
    request.timeoutInterval= 6.0f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[GLMusicPlayer defaultPlayer].authToken forHTTPHeaderField:@"auth-token"];
    [request setValue:[GLMusicPlayer defaultPlayer].studentid forHTTPHeaderField:@"studentid"];
    [request setValue:musicId forHTTPHeaderField:@"audioId"];
    // 设置body
    [request setHTTPBody:body];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            id responseDictionary = responseObject[@"success"];
            if ([responseDictionary isKindOfClass:[NSNull class]]) {
                fail(1,@"无数据");
                return ;
            }
            
            success(responseObject);
        } else {
            fail(NetError,[error localizedDescription]);
        }
    }] resume];
}


- (void)musicDeleteCollectionRequestMusicId:(NSString *)musicId Success:(LXObjectSuccess)success fail:(ESNetworkFail)fail{
    [self idCheck];
    NSString *parame = [NSString stringWithFormat:@"{\"functionName\":\"StudentDeleteAudioFromFavorite\",\"parameters\":{\"audioId\":[\"%@\"]}}",musicId] ;
    NSData * body = [parame dataUsingEncoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:baseApi parameters:nil error:nil];
    request.timeoutInterval= 6.0f;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[GLMusicPlayer defaultPlayer].authToken forHTTPHeaderField:@"auth-token"];
    [request setValue:[GLMusicPlayer defaultPlayer].studentid forHTTPHeaderField:@"studentid"];
    [request setValue:musicId forHTTPHeaderField:@"audioId"];
    // 设置body
    [request setHTTPBody:body];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            id responseDictionary = responseObject[@"success"];
            if ([responseDictionary isKindOfClass:[NSNull class]]) {
                fail(1,@"无数据");
                return ;
            }
            
            success(responseObject);
        } else {
            fail(NetError,[error localizedDescription]);
        }
    }] resume];
}

- (void)monitorNetworking
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case -1:
//                NSLog(@"未知网络");
//                break;
//            case 0:
//                NSLog(@"网络不可达");
//                break;
//            case 1:
//            {
//                NSLog(@"GPRS网络");
//                //发通知，带头搞事
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"1" userInfo:nil];
//            }
//                break;
//            case 2:
//            {
//                NSLog(@"wifi网络");
//                //发通知，搞事情
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"2" userInfo:nil];
//            }
//                break;
//            default:
//                break;
//        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
        }else{
            NSLog(@"没网");
        }
    }];
}

@end
