//
//  Utility.m
//  lexiwed2
//
//  Created by Kyle on 2017/3/14.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "Utility.h"


static NSString *urlExpression = @"((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((:[0-9]+)?)((?:\\/[\\+~%\\/\\.\\w\\-]*)?\\??(?:[\\-\\+=&;%@\\.\\w]*)#?(?:[\\.\\!\\/\\\\\\w]*))?)";

static NSString *kLinkPlacedString = @"🔗网页地址";
static NSString *kMemberStringPlus = @", ";
static NSString *kMjRequestKey = @"Mijwed#iZbp1ftjj9sbiksic32yr1Z!";

@interface Utility()
{
    NSUInteger _replaceLength;
}

@property (nonatomic, strong) NSDateFormatter *yearDayFormat;
@property (nonatomic, strong) NSDateFormatter *monthFormat;
@property (nonatomic, strong) NSDateFormatter *dayFormat;
@property (nonatomic, strong) NSDateFormatter *hourFormat;
@property (nonatomic, strong) NSDateFormatter *noSecondsFormat;
@property (nonatomic, strong) NSDateFormatter *monthDayFormat;
@property (nonatomic, strong) NSDateFormatter *chineseFormat;

@property (nonatomic, strong) NSDateFormatter *chineseNoSecondFormat;

@property (nonatomic, strong) NSRegularExpression *urlRegex;

@property (nonatomic, strong) UIFont *liveContentFont;
@property (nonatomic, strong) UIColor *liveContentColor;
@property (nonatomic, strong) UIColor *liveTopicContentColor;

@property (nonatomic, strong) UIFont *liveReplyFont;
@property (nonatomic, strong) UIColor *liveReplyColor;
@property (nonatomic, strong) UIColor *liveReplyLinkColor;

@property (nonatomic, strong) NSMutableDictionary *placeholdDictionary;

@property (nonatomic, strong) NSArray *characterArray;
@end


@implementation Utility

static Utility* _instance = nil;

+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;

    return _instance ;
}


-(instancetype)init{
    if (self = [super init]){
        _replaceLength = kLinkPlacedString.length;
    }
    return self;
}

-(NSArray *)characterArray{
    if (_characterArray != nil){
        return _characterArray;
    }
    _characterArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    return _characterArray;
}


-(NSRegularExpression *)urlRegex{
    if (_urlRegex != nil){
        return _urlRegex;
    }
    _urlRegex = [NSRegularExpression regularExpressionWithPattern:urlExpression
                                                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    return _urlRegex;
}


-(NSMutableDictionary *)placeholdDictionary{
    if (_placeholdDictionary != nil){
        return _placeholdDictionary;
    }
    _placeholdDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    return _placeholdDictionary;
}



-(UIFont *)liveContentFont{
    if (_liveContentFont != nil){
        return _liveContentFont;
    }
     _liveContentFont = [UIFont systemFontOfSize:16.0f];
    return _liveContentFont;
}


-(UIFont *)liveReplyFont{
    if (_liveReplyFont != nil){
        return _liveReplyFont;
    }
    _liveReplyFont = [UIFont systemFontOfSize:14.0f];
    return _liveReplyFont;
}


-(NSDateFormatter *)yearDayFormat{
    if (_yearDayFormat != nil){
        return _yearDayFormat;
    }
    _yearDayFormat = [[NSDateFormatter alloc] init];
    [_yearDayFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return _yearDayFormat;
}
-(NSDateFormatter *)noSecondsFormat{
    if (_noSecondsFormat != nil){
        return _noSecondsFormat;
    }
    _noSecondsFormat = [[NSDateFormatter alloc] init];
    [_noSecondsFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    return _noSecondsFormat;
}

- (NSDateFormatter *)chineseNoSecondFormat{
    if (_chineseNoSecondFormat != nil){
        return _chineseNoSecondFormat;
    }
    _chineseNoSecondFormat = [[NSDateFormatter alloc] init];
    [_chineseNoSecondFormat setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return _chineseNoSecondFormat;
}

-(NSDateFormatter *)monthFormat{
    if (_monthFormat != nil){
        return _monthFormat;
    }
    _monthFormat = [[NSDateFormatter alloc] init];
    [_monthFormat setDateFormat:@"yyyy-MM"];
    return _monthFormat;
}

-(NSDateFormatter *)monthDayFormat{
    if (_monthDayFormat != nil){
        return _monthDayFormat;
    }
    _monthDayFormat = [[NSDateFormatter alloc] init];
    [_monthDayFormat setDateFormat:@"MM月dd日"];
    return _monthDayFormat;
}

-(NSDateFormatter *)dayFormat{
    if (_dayFormat != nil){
        return _dayFormat;
    }
    _dayFormat = [[NSDateFormatter alloc] init];
    [_dayFormat setDateFormat:@"yyyy-MM-dd"];
    return _dayFormat;
}

-(NSDateFormatter *)hourFormat{
    if (_hourFormat != nil){
        return _hourFormat;
    }
    _hourFormat = [[NSDateFormatter alloc] init];
    [_hourFormat setDateFormat:@"HH:mm"];
    return _hourFormat;
}

- (NSDateFormatter *)chineseFormat{
    if (_chineseFormat != nil) {
        return _chineseFormat;
    }
    _chineseFormat = [[NSDateFormatter alloc] init];
    [_chineseFormat setDateFormat:@"yyyy年MM月dd日"];
    return _chineseFormat;
}

+(NSDate *)parseDay:(NSString *)sdate{
    
    return [[self shareInstance] paraseYearDay:sdate];
    
}



-(NSDate *)paraseYearDay:(NSString *)sdate{
    
    if (sdate == nil || sdate.length == 0){
        return [NSDate date];
    }
    NSDate *date = [self.dayFormat dateFromString:sdate];
    if (date == nil){
        return [NSDate date];
    }
    return date;
}



+(NSDate *)parseDate:(NSString *)sdate{

    return [[self shareInstance] paraseYearDayDate:sdate];

}



-(NSDate *)paraseYearDayDate:(NSString *)sdate{

    if (sdate == nil || sdate.length == 0){
        return [NSDate date];
    }
    NSDate *date = [self.yearDayFormat dateFromString:sdate];
    if (date == nil){
        date = [self.dayFormat dateFromString:sdate];
        if (date == nil) {
            return [NSDate date];
        }
        return date;
    }
    return date;
}


+(NSDate *)parseMonthDate:(NSString *)sdate{
    return [[self shareInstance] paraseYearMonthDate:sdate];
}

-(NSDate *)paraseYearMonthDate:(NSString *)sdate{

    if (sdate == nil || sdate.length == 0){
        return [NSDate date];
    }
    NSDate *date = [self.monthFormat dateFromString:sdate];
    if (date == nil){
        return [NSDate date];
    }
    return date;
}

+(NSDate *)parseYearMonthDayDate:(NSString *)sdate{
    return [[self shareInstance] paraseYearMonthDayDate:sdate];
}

-(NSDate *)paraseYearMonthDayDate:(NSString *)sdate{
    
    if (sdate == nil || sdate.length == 0){
        return [NSDate date];
    }
    NSDate *date = [self.dayFormat dateFromString:sdate];
    if (date == nil){
        return [NSDate date];
    }
    return date;
}


+(NSDate *)parseNoSecondsDate:(NSString *)sdate{
    return [[self shareInstance] paraseNoSecondsDate:sdate];
}

-(NSDate *)paraseNoSecondsDate:(NSString *)sdate{
    
    if (sdate == nil || sdate.length == 0){
        return [NSDate date];
    }
    NSDate *date = [self.noSecondsFormat dateFromString:sdate];
    if (date == nil){
        return [NSDate date];
    }
    return date;
}



+(NSString *)displayTimeFormat:(NSDate *)date{

    return [[self shareInstance] displayTimeString:date];
}

-(NSString *)displayTimeString:(NSDate *)date{

    if (date == nil){
        return @"刚刚";
    }

    NSTimeInterval dateTimeInterval = [date timeIntervalSince1970];
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];

    NSTimeInterval timeGap = nowTimeInterval - dateTimeInterval;
    if (timeGap < 5*60){
        return @"刚刚";
    }else if (timeGap < 60*60){

        NSUInteger minute = timeGap/60;
        return [NSString stringWithFormat:@"%ld分钟前",minute];
    }

    NSString *todayBeginString = [self.dayFormat stringFromDate:[NSDate date]];
    NSDate *todayBegin = [self.dayFormat dateFromString:todayBeginString];

    NSTimeInterval todayBeginInterval = [todayBegin timeIntervalSince1970];

    if(dateTimeInterval > todayBeginInterval){


        NSString *todayBeginString = [self.hourFormat stringFromDate:date];
        return [NSString stringWithFormat:@"今天%@",todayBeginString];
    }else if(dateTimeInterval > todayBeginInterval - 60*60*24){
        NSString *todayBeginString = [self.hourFormat stringFromDate:date];
        return [NSString stringWithFormat:@"昨天%@",todayBeginString];
    }
    
    return [self.yearDayFormat stringFromDate:date];


}

+(NSString *)yearMonthFormat:(NSDate *)date{
   return [[self shareInstance] yearMonthString:date];
}




-(NSString *)yearMonthString:(NSDate *)date{

    if (date == nil){
        return @"2017-01";
    }

    return [self.monthFormat stringFromDate:date];
    
    
}
+(NSString *)monthDayFormat:(NSDate *)date{
    return [[self shareInstance] monthDayString:date];
}

- (NSString *)monthDayString:(NSDate *)date{
    if (date == nil) {
        return @"01月01日";
    }
    return [self.monthDayFormat stringFromDate:date];
}

+(NSString *)yearMonthDayFormat:(NSDate *)date{
    return [[self shareInstance] yearMonthDayString:date];
}

-(NSString *)yearMonthDayString:(NSDate *)date{

    if (date == nil){
        return @"2017-01-01";
    }

    return [self.dayFormat stringFromDate:date];
    
}

+ (NSString *)yearMonthDayChineseString:(NSDate *)date{
    return [[self shareInstance] chineseString:date];
}

- (NSString *)chineseString:(NSDate *)date{
    
    if (date == nil){
        date = [NSDate date];
    }
    
    return [self.chineseFormat stringFromDate:date];
    
    
}


+(NSString *)dateChineseFormat:(NSDate *)date{
    return [[self shareInstance] dateChineseFormatString:date];
}

-(NSString *)dateChineseFormatString:(NSDate *)date{
    
    if (date == nil){
        date = [NSDate date];
    }
    
    return [self.chineseNoSecondFormat stringFromDate:date];
}


+(NSString *)yearMonthDayHoursMinutesSecondsFormat:(NSDate *)date{
    return [[self shareInstance] yearMonthDayHoursMinutesSecondsString:date];
}

-(NSString *)yearMonthDayHoursMinutesSecondsString:(NSDate *)date{
    
    if (date == nil){
        date = [NSDate date];
    }
    
    return [self.yearDayFormat stringFromDate:date];
}

+(NSString *)yearMonthDayHoursMinutesFormat:(NSDate *)date{
    return [[self shareInstance] yearMonthDayHoursMinutesString:date];
}

-(NSString *)yearMonthDayHoursMinutesString:(NSDate *)date{
    
    if (date == nil){
        date = [NSDate date];
    }
    
    return [self.noSecondsFormat stringFromDate:date];
}

+ (UIImage *)generateImageWith:(UIView *)view{

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);  // high res
    // Make the CALayer to draw in our "canvas".
    [[view layer] renderInContext: UIGraphicsGetCurrentContext()];


    // Fetch an UIImage of our "canvas".
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // Stop the "canvas" from accepting any input.
    UIGraphicsEndImageContext();


    return image;

}



+(void)lxGCDDelay:(NSTimeInterval)delay closure:(lxTapAction)closure{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (closure){
            closure();
        }

    });
}


-(NSString *)keyForImageWithSize:(CGSize)size{ //TODO:Kyle 待修改
    NSInteger width = size.width/10;
    NSInteger height = size.height/10;
    if (size.width > 10000){
        
    }

    return [NSString stringWithFormat:@"place_key_%ld_%ld",width,height];

}

//+(NSString *)copyrightString:(long long)time{
//    long long totalMilliseconds = time + 20171204;
//    return [[NSString stringWithFormat:@"%lld%@%@%@",totalMilliseconds,kMjRequestKey,[FCUUID uuidForDevice],[LXUserManager shareInstance].getLoginUId] sha256] ;
//}


+(long long)getCurrentDateTimeTOMilliSeconds
{
    NSDate *datetime = [NSDate date];
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    return totalMilliseconds;
}


/**
 *  是否为同一天
 */
+ (BOOL)isSameDay:(NSString *)date1 date2:(NSString*)date2
{
    if (date1.length <= 0) {
        return NO;
    }
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[Utility parseDate:date1]];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:[Utility parseDate:date2]];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


+(NSString *)characterForIndex:(NSUInteger)index{
    return [[self shareInstance] characterIndex:index];
}

-(NSString *)characterIndex:(NSUInteger)index{
    if (self.characterArray.count > index){
        return self.characterArray[index];
    }
    return self.characterArray.lastObject;
}


+(UIFont *)light_pingfang:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Light" size:size];
}
+(UIFont *)medium_pingfang:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
}
+(UIFont *)regular_pingfang:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}
+(UIFont *)semibold_pingfang:(CGFloat)size{
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
}

+(UIFont *)bold_SourceSansPro:(CGFloat)size{
    return [UIFont fontWithName:@"SourceSansPro-Bold" size:size];
}
+(UIFont *)black_SourceSansPro:(CGFloat)size{
    return [UIFont fontWithName:@"SourceSansPro-Black" size:size];
}

+(UIFont *)medium_Barlow:(CGFloat)size{
    return [UIFont fontWithName:@"Barlow-Medium" size:size];
}

+ (NSString *)AndroidStringForTransform:(CGAffineTransform)transform{
    NSArray *array = @[@(transform.a),@(transform.c),@(transform.tx),
                       @(transform.b),@(transform.d),@(transform.ty),
                       @(0),@(0),@(1.0)
                       ];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *strM = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return strM;
}

+ (CGAffineTransform)AndroidTransformForString:(NSArray *)array{
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (array.count < 9) {
        return transform;
    }
    transform = CGAffineTransformMake([array[0] doubleValue], [array[3] doubleValue],
                                      [array[1] doubleValue], [array[4] doubleValue],
                                      [array[2] doubleValue], [array[5] doubleValue]);
    return transform;
}



@end
