//
//  XJNoticeHelpView.h
//  LearnFM
//
//  Created by 何学杰 on 2018/9/26.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XJNoticeHelpView : UIView
@property (strong, nonatomic) UILabel *midLabel;
@property (strong, nonatomic) UIView *maskView;
//@property (weak, nonatomic) UIButton *maskButtom;

- (void)showNotice;

@end

NS_ASSUME_NONNULL_END
