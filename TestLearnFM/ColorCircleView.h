//
//  ColorCircleView.h
//  TestLearnFM
//
//  Created by 何学杰 on 2018/11/1.
//  Copyright © 2018年 何学杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorCircleView : UIView

//数组里面装的是字典，，字典里有两个key -> strokeColor和precent

@property (nonatomic,assign) NSArray *circleArray;

@end

NS_ASSUME_NONNULL_END
