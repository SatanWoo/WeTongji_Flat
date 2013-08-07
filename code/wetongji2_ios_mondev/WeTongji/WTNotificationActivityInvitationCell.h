//
//  WTNotificationActivityInvitationCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-3-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNotificationCell.h"
#import "WTNotificationInvitationCell.h"

@class ActivityInvitationNotification;

@interface WTNotificationActivityInvitationCell : WTNotificationInvitationCell

+ (NSMutableAttributedString *)generateNotificationContentAttributedString:(ActivityInvitationNotification *)invitation;

@end
