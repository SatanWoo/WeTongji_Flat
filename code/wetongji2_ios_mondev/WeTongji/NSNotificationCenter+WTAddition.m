//
//  NSNotificationCenter+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "NSNotificationCenter+WTAddition.h"

#define kWTInnerSettingItemDidModify        @"WTInnerSettingItemDidModify"
#define kWTCurrentUserDidChange             @"WTCurrentUserDidChange"
#define kWTDidLoadUnreadNotifications       @"WTDidLoadUnreadNotifications"
#define kWTUserDidCheckNotifications        @"WTUserDidCheckNotifications"

@implementation NSNotificationCenter (WTAddition)

+ (void)postInnerSettingItemDidModifyNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWTInnerSettingItemDidModify object:nil userInfo:nil];
}

+ (void)registerInnerSettingItemDidModifyNotificationWithSelector:(SEL)aSelector
                                                           target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kWTInnerSettingItemDidModify
                 object:nil];
}

+ (void)postCurrentUserDidChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWTCurrentUserDidChange object:nil userInfo:nil];
}

+ (void)registerCurrentUserDidChangeNotificationWithSelector:(SEL)aSelector
                                                      target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kWTCurrentUserDidChange
                 object:nil];
}

+ (void)postDidLoadUnreadNotificationsNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWTDidLoadUnreadNotifications object:nil userInfo:nil];
}

+ (void)registerDidLoadUnreadNotificationsNotificationWithSelector:(SEL)aSelector
                                                      target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kWTDidLoadUnreadNotifications
                 object:nil];
}

+ (void)postUserDidCheckNotificationsNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kWTUserDidCheckNotifications object:nil userInfo:nil];
}

+ (void)registerUserDidCheckNotificationsNotificationWithSelector:(SEL)aSelector
                                                            target:(id)aTarget {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:aTarget selector:aSelector
                   name:kWTUserDidCheckNotifications
                 object:nil];
}

@end
