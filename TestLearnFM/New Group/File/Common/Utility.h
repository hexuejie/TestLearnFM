//
//  Utility.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/14.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]
#define AppBuildNumber   [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"]


@class LXLinkContentModel;
@class LXRewardUserLinkDisplayModel;

typedef void(^lxTapAction)(void);

typedef enum LXPlachImageType : NSUInteger {
    LXPlachImageSmall,
    LXPlachImageBig,
    LXPlachImageCircle,
    LXPlachImageSmallFill,
    LXPlachImageCircleFill,
    LXPlachImageBackground,
} LXPlachImageType;

@interface Utility : NSObject

@property (nonatomic, readonly) NSRegularExpression *urlRegex;
@property (nonatomic, readonly) UIFont *liveContentFont;
@property (nonatomic, readonly) UIColor *liveContentColor;
@property (nonatomic, readonly) UIColor *liveTopicContentColor;

@property (nonatomic, readonly) UIFont *liveReplyFont;
@property (nonatomic, readonly) UIColor *liveReplyColor;
@property (nonatomic, readonly) UIColor *liveReplyLinkColor;

+(instancetype) shareInstance;
+(LXLinkContentModel *)delechLinkContent:(NSString *)plainText;
+(LXRewardUserLinkDisplayModel *)createUsersLinkDataArray:(NSArray *)users;

+(NSDate *)parseDay:(NSString *)sdate;
+(NSDate *)parseDate:(NSString *)sdate;
+(NSDate *)parseMonthDate:(NSString *)sdate;
+(NSDate *)parseNoSecondsDate:(NSString *)sdate;
+(NSDate *)parseYearMonthDayDate:(NSString *)sdate;


+(NSString *)yearMonthDayChineseString:(NSDate *)date;
+(NSString *)monthDayFormat:(NSDate *)date;
+(NSString *)displayTimeFormat:(NSDate *)date;
+(NSString *)yearMonthFormat:(NSDate *)date;
+(NSString *)yearMonthDayFormat:(NSDate *)date;
+(NSString *)yearMonthDayHoursMinutesSecondsFormat:(NSDate *)date;
+(NSString *)yearMonthDayHoursMinutesFormat:(NSDate *)date;
+(NSString *)dateChineseFormat:(NSDate *)date;
+(UIImage *)generateImageWith:(UIView *)view;

+(void)lxGCDDelay:(NSTimeInterval)delay closure:(lxTapAction)closure;

+(UIImage *)lxPlaceholdImage:(CGSize)size type:(LXPlachImageType)type;
+(UIImage *)lxBigPlaceholdImage:(CGSize)size;
+(void)cleanAllCreateImage;

+(CGFloat) segmentTopMinHeight;
+(CGFloat) safeAreaBottomPlus;
+(CGFloat) hiddenTopStatusBarPlus;

+(long long)getCurrentDateTimeTOMilliSeconds;
+(NSString *)copyrightString:(long long)time;
+ (BOOL)isSameDay:(NSString *)date1 date2:(NSString*)date2;
//根据顺序得到字母
+(NSString *)characterForIndex:(NSUInteger)index;
//字体库
+(UIFont *)light_pingfang:(CGFloat)size;
+(UIFont *)medium_pingfang:(CGFloat)size;
+(UIFont *)regular_pingfang:(CGFloat)size;
+(UIFont *)semibold_pingfang:(CGFloat)size;
+(UIFont *)bold_SourceSansPro:(CGFloat)size;
+(UIFont *)black_SourceSansPro:(CGFloat)size;
+(UIFont *)medium_Barlow:(CGFloat)size; //数字字体

+ (NSString *)AndroidStringForTransform:(CGAffineTransform)transform;
+ (CGAffineTransform)AndroidTransformForString:(NSArray *)array;
@end
