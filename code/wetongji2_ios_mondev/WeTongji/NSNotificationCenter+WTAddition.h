//
//  NSNotificationCenter+WTAddition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (WTAddition)

+ (void)postInnerSettingItemDidModifyNotification;

+ (void)registerInnerSettingItemDidModifyNotificationWithSelector:(SEL)aSelector
                                                           target:(id)aTarget;

+ (void)postCurrentUserDidChangeNotification;

+ (void)registerCurrentUserDidChangeNotificationWithSelector:(SEL)aSelector
                                                      target:(id)aTarget;

+ (void)postDidLoadUnreadNotificationsNotification;

+ (void)registerDidLoadUnreadNotificationsNotificationWithSelector:(SEL)aSelector
                                                            target:(id)aTarget;

+ (void)postUserDidCheckNotificationsNotification;

+ (void)registerUserDidCheckNotificationsNotificationWithSelector:(SEL)aSelector
                                                           target:(id)aTarget;

@end
