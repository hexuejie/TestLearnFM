//
//  UIButton+EdgeInsets.h
//  lexiwed2
//
//  Created by Kyle on 2017/4/6.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LXImagePositionType) {
    LXImagePositionTypeLeft,   //图片在左，标题在右，默认风格
    LXImagePositionTypeRight,  //图片在右，标题在左
    LXImagePositionTypeTop,    //图片在上，标题在下
    LXImagePositionTypeBottom  //图片在下，标题在上
};

typedef NS_ENUM(NSInteger, LXEdgeInsetsType) {
    LXEdgeInsetsTypeTitle,//标题
    LXEdgeInsetsTypeImage//图片
};

typedef NS_ENUM(NSInteger, LXMarginType) {
    LXMarginTypeTop         ,
    LXMarginTypeBottom      ,
    LXMarginTypeLeft        ,
    LXMarginTypeRight       ,
    LXMarginTypeTopLeft     ,
    LXMarginTypeTopRight    ,
    LXMarginTypeBottomLeft  ,
    LXMarginTypeBottomRight
};


@interface UIButton(EdgeInsets)


/**
 默认情况下，imageEdgeInsets和titleEdgeInsets都是0。先不考虑height,

 if (button.width小于imageView上image的width){图像会被压缩，文字不显示}

 if (button.width < imageView.width + label.width){图像正常显示，文字显示不全}

 if (button.width >＝ imageView.width + label.width){图像和文字都居中显示，imageView在左，label在右，中间没有空隙}
 */



/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现图片和标题的自由排布
 *  注意：1.该方法需在设置图片和标题之后才调用;
 2.图片和标题改变后需再次调用以重新计算titleEdgeInsets和imageEdgeInsets
 *
 *  @param type    图片位置类型
 *  @param spacing 图片和标题之间的间隙
 */
- (void)setImagePositionWithType:(LXImagePositionType)type spacing:(CGFloat)spacing;

/**
 *  按钮只设置了title or image，该方法可以改变它们的位置
 *
 *  @param edgeInsetsType <#edgeInsetsType description#>
 *  @param marginType     <#marginType description#>
 *  @param margin         <#margin description#>
 */
- (void)setEdgeInsetsWithType:(LXEdgeInsetsType)edgeInsetsType marginType:(LXMarginType)marginType margin:(CGFloat)margin;






@end
