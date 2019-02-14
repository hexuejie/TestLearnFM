//
//  XJTokenTipsView.h
//  TestLearnFM
//
//  Created by 何学杰 on 2018/12/18.
//  Copyright © 2018年 何学杰. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^musicLoginBlock)(void);

@interface XJTokenTipsView : UIView

@property (nonatomic,strong) UIButton *bottomView;

@property (nonatomic,strong) UIButton *tipView;
@property (nonatomic,strong) UILabel *tipTitleLabel;
@property (nonatomic,strong) UILabel *tipContentLabel;
@property (nonatomic,strong) UIButton *loginButton;
@property (nonatomic,strong) UIButton *concalButton;

@property (nonatomic,copy) musicLoginBlock block;//定义一个MyBlock属性


@property (nonatomic,assign) BOOL concalTag;
@end

NS_ASSUME_NONNULL_END
