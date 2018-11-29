//
//  UIImage+Extension.h
//  lexiwed2
//
//  Created by Kyle on 2017/3/21.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Extension)


- (UIImage *)image:(UIImage *)image withColor:(UIColor *)color;
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+(UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)resizableImageWithName:(NSString *)imageName;
+ (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath;
- (UIImage *)circleImage;

+(UIImage *)getTheLaunchImage;
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;
@end
