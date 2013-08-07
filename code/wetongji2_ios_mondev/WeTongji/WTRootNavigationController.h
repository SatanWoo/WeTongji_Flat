//
//  WTNavigationController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNavigationViewController.h"

typedef enum {
    WTDisableNavBarTypeNone,
    WTDisableNavBarTypeLeft,
    WTDisableNavBarTypeRight,
} WTDisableNavBarType;

@protocol WTRootNavigationControllerDelegate;

@class WTInnerModalViewController;

@interface WTRootNavigationController : WTNavigationViewController

- (void)showInnerModalViewController:(WTInnerModalViewController *)innerController
                sourceViewController:(UIViewController<WTRootNavigationControllerDelegate> *)sourceController
                   disableNavBarType:(WTDisableNavBarType)type;

- (void)hideInnerModalViewController;

- (BOOL)needUserLogin;

@end

@protocol WTRootNavigationControllerDelegate <NSObject>

@optional

- (void)didHideInnderModalViewController;

- (void)willHideInnderModalViewController;

- (UIScrollView *)sourceScrollView;

@end
