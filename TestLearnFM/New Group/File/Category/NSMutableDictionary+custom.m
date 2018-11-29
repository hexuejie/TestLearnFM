//
//  NSMutableDictionary+custom.m
//  lexiwed2
//
//  Created by pxj on 16/10/13.
//  Copyright © 2016年 乐喜网. All rights reserved.
//

#import "NSMutableDictionary+custom.h"

@implementation NSMutableDictionary (custom)

/**
 *  自定义字典赋值（防止程序崩溃）
 *
 *  @param anObject 字典的存的对象
 *  @param aKey     字典的存的key
 */
- (void)customSetObject:(id)anObject forKey:(id)aKey{
    if (aKey == nil||[aKey isEqualToString:@""]) {
        return;
    }else{
        if (anObject == nil) {
            anObject = @"";
        }
        [self setObject:anObject forKey:aKey];
    }
}
@end
