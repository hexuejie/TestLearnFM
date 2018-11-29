//
//  UINavigationController+extension.h
//  lexiwed2
//
//  Created by Kyle on 2017/5/12.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController(extension)

-(void)deleteViewControllerClass:(Class _Nonnull )viewControllerClass;
-(void)deleteViewControllers:(NSArray<UIViewController *>*_Nonnull)array;

- (void)pushViewController:(UIViewController* _Nonnull)viewController animated:(BOOL)animated completion: (void (^ __nullable)(void))completion;  // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated completion: (void (^ __nullable)(void))completion; // Returns the popped controller.

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController * _Nonnull)viewController animated:(BOOL)animated  completion: (void (^ __nullable)(void))completion; // Pops view controllers until the one specified is on top. Returns the popped controllers.

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated  completion: (void (^ __nullable)(void))completion; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.

@end
