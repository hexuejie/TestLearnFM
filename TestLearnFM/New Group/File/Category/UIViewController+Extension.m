//
//  UIViewController+Extension.m
//  lexiwed2
//
//  Created by Kyle on 2017/4/6.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "UINavigationController+extension.h"
//#import "lexiwed2-Swift.h"

@implementation UIViewController(Extension)


- (UIViewController *)lx_topMostController {
    return [self lx_topViewControllerWithRootViewController];
}

- (UIViewController *)lx_topViewControllerWithRootViewController {
    if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)self;
        return [tabBarController.selectedViewController lx_topViewControllerWithRootViewController];
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)self;
        NSArray *subViewControllers = navigationController.viewControllers;
        return [subViewControllers.lastObject lx_topViewControllerWithRootViewController];
    } else if (self.presentedViewController && [self.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController* presentedViewController = self.presentedViewController;
        return [presentedViewController lx_topViewControllerWithRootViewController];
    } else {
        return self;
    }
}


-(void)dismiss:(void (^ __nullable)(void))complete{

    [self dismissViewControllerAnimated:true completion:^{

        if (complete != nil){
            complete();
        }
    }];

}

-(void)popToRootViewControllerAnimation:(BOOL)animate completion:(void (^)(void))completion{
    UINavigationController *navi = self.navigationController;
    if (navi == nil){
        return;
    }
    [navi popToRootViewControllerAnimated:animate completion:^{
        if (completion != nil){
            completion();
        }
    }];
}

-(void)popViewController:( UIViewController* _Nullable )viewController{
    [self popViewController:viewController completion:nil];
}


-(void)popViewController:(UIViewController * _Nullable)viewController completion:(void (^)(void))completion{

    [self popViewController:viewController animation:true completion:completion];
}

-(void)popViewController:(UIViewController * _Nullable)viewController animation:(BOOL)animate completion:(void (^)(void))completion{

    UINavigationController *navi = self.navigationController;
    if (navi == nil){
        return;
    }

    if (viewController != nil){
        [navi popToViewController:viewController animated:animate completion:^{
            if (completion != nil){
                completion();
            }
        }];
    }else{
        [navi popViewControllerAnimated:animate completion:^{
            if (completion != nil){
                completion();
            }
        }];
    }
}



-(void)pushViewController:(UIViewController * __nonnull)viwController{

    UINavigationController *navi = self.navigationController;
    if (navi == nil){
        return;
    }
    [navi pushViewController:viwController animated:true completion:nil];
}

-(void)pushViewController:(UIViewController * __nonnull)viwController completion:(void (^)(void))completion{
    [self pushViewController:viwController animate:true completion:completion];
}


-(void)pushViewController:(UIViewController * __nonnull)viwController animate:(BOOL)animated completion:(void (^)(void))completion{
    UINavigationController *navi = self.navigationController;
    if (navi == nil){
        return;
    }
    [navi pushViewController:viwController animated:animated completion:^{
        if (completion ){
            completion();
        }
    }];
}


-(void)present:(UIViewController *)viewController completion:(void (^)(void))completion{

    [self presentViewController:viewController animated:true completion:^{
        if (completion != nil){
            completion();
        }
    }];
}


@end
