//
//  UIViewController+Extension.h
//  lexiwed2
//
//  Created by Kyle on 2017/4/6.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Extension)

- (UIViewController *)lx_topMostController;

- (UIViewController *)lx_topViewControllerWithRootViewController;

-(void)dismiss:(void (^ __nullable)(void))complete;
-(void)popViewController:( UIViewController* _Nullable )viewController;
-(void)popViewController:(UIViewController * _Nullable)viewController completion:(void (^)(void))completion;
-(void)popToRootViewControllerAnimation:(BOOL)animate completion:(void (^)(void))completion;
-(void)popViewController:(UIViewController * _Nullable)viewController animation:(BOOL)animate completion:(void (^)(void))completion;

-(void)pushViewController:(UIViewController * __nonnull)viwController;
-(void)pushViewController:(UIViewController * __nonnull)viwController completion:(void (^)(void))completion;
-(void)pushViewController:(UIViewController * __nonnull)viwController animate:(BOOL)animated completion:(void (^)(void))completion;

-(void)present:(UIViewController *)viewController completion:(void (^)(void))completion;


@end
