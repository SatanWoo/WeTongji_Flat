//
//  Notification+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Notification.h"
#import "ActivityInvitationNotification.h"
#import "CourseInvitationNotification.h"
#import "FriendInvitationNotification.h"

@interface Notification (Addition)

+ (void)deleteNotificationWithID:(NSString *)notificationID;

- (NSString *)customCellClassName;

- (CGFloat)cellHeight;

+ (NSSet *)insertNotifications:(NSDictionary *)dict;

+ (void)clearOutdatedNotifications;

@end
