//
//  WTResourceFactory.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTResourceFactory : NSObject

+ (UIButton *)createNormalButtonWithText:(NSString *)text;

+ (UIButton *)createFocusButtonWithText:(NSString *)text;

+ (UIButton *)createDisableButtonWithText:(NSString *)text;

+ (UIButton *)createTranslucentButtonWithText:(NSString *)text;

+ (UIBarButtonItem *)createBackBarButtonWithText:(NSString *)text
                                   target:(id)target
                                   action:(SEL)action;

+ (UIBarButtonItem *)createBackBarButtonWithText:(NSString *)text
                                          target:(id)target
                                          action:(SEL)action
                              restrictToMaxWidth:(BOOL)restrictToMaxWidth;

+ (UIBarButtonItem *)createNormalBarButtonWithText:(NSString *)text
                                            target:(id)target
                                            action:(SEL)action;

+ (UIBarButtonItem *)createFocusBarButtonWithText:(NSString *)text
                                           target:(id)target
                                           action:(SEL)action;

+ (UIView *)createNavigationBarTitleViewWithText:(NSString *)text;

+ (UIBarButtonItem *)createLogoBackBarButtonWithTarget:(id)target
                                                action:(SEL)action;

+ (UIBarButtonItem *)createFilterBarButtonWithTarget:(id)target
                                              action:(SEL)action
                                               focus:(BOOL)focus;

+ (UIBarButtonItem *)createNewPostBarButtonWithTarget:(id)target
                                               action:(SEL)action;

+ (UIBarButtonItem *)createSettingBarButtonWithTarget:(id)target
                                            action:(SEL)action;

+ (UIButton *)createLockButtonWithTarget:(id)target
                                  action:(SEL)action;

+ (UIBarButtonItem *)createBarButtonWithButton:(UIButton *)button;

+ (UIView *)createPlaceholderViewWithScrollView:(UIScrollView *)scrollView;

+ (UIButton *)createAddFriendButtonWithTarget:(id)target
                                       action:(SEL)action;

+ (UIBarButtonItem *)createAddFriendBarButtonWithTarget:(id)target
                                                 action:(SEL)action;

+ (void)configureActivityIndicatorBarButton:(UIBarButtonItem *)barButtonItem
                     activityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

+ (void)configureActivityIndicatorButton:(UIButton *)button
                  activityIndicatorStyle:(UIActivityIndicatorViewStyle)style;

@end
