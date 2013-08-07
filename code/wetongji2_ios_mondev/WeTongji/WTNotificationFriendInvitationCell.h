//
//  WTNotificationFriendInvitationCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNotificationInvitationCell.h"

@class FriendInvitationNotification;

@interface WTNotificationFriendInvitationCell : WTNotificationInvitationCell

+ (NSMutableAttributedString *)generateNotificationContentAttributedString:(FriendInvitationNotification *)invitation;

@end
