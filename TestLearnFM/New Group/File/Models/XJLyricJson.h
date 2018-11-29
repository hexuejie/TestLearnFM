//
//  XJLyricJson.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XJLyricJson : BaseObject


@property (nonatomic, assign) NSTimeInterval msTime;
/** 秒 */
//@property (nonatomic, assign) NSTimeInterval secTime;
///** 时间字符串 */
//@property (nonatomic, copy) NSString *timeString;
/** 歌词内容 */
@property (nonatomic, copy) NSString *content;

@end

NS_ASSUME_NONNULL_END
