//
//  NSUserDefaults+WTSDKAddition.h
//  WeTongji
//
//  Created by 紫川 王 on 12-4-28.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (WTSDKAddition)

+ (void)setCurrentUserID:(NSString *)userID session:(NSString *)session;
+ (NSString *)getCurrentUserID;
+ (NSString *)getCurrentUserSession;

+ (BOOL)useTestServer;
+ (void)setUseTestServer:(BOOL)useTestServer;

@end
