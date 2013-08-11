//
//  InvitationNotification.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Notification.h"
@interface InvitationNotification : Notification

@property (nonatomic, retain) NSNumber * accepted;

@end
