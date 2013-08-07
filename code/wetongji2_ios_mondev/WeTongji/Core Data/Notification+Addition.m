//
//  Notification+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-3-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Notification+Addition.h"
#import "WTCoreDataManager.h"
#import "FriendInvitationNotification.h"
#import "ActivityInvitationNotification.h"
#import "CourseInvitationNotification.h"
#import "User+Addition.h"
#import "WTNotificationFriendInvitationCell.h"
#import "NSString+WTAddition.h"
#import "Activity+Addition.h"
#import "Course+Addition.h"
#import "Object+Addition.h"

@implementation Notification (Addition)

+ (NSSet *)insertNotifications:(NSDictionary *)dict {
    NSMutableSet *result = [NSMutableSet set];
    NSArray *notificationsInfoArray = dict[@"Notifications"];
    for (NSDictionary *info in notificationsInfoArray) {
        NSString *notificationType = [NSString stringWithFormat:@"%@", info[@"SourceType"]];
        NSDictionary *sourceDetailsInfo = info[@"SourceDetails"];
        
        // TODO:
//        if (sourceDetailsInfo[@"RejectedAt"]) {
//            if (![[NSString stringWithFormat:@"%@", sourceDetailsInfo[@"RejectedAt"]] isEqualToString:@"<null>"]) {
//                WTLOGERROR(@"Rejected at is not null");
//                continue;
//            }
//        }
        Notification *notification = nil;
        if ([notificationType isEqualToString:@"FriendInvite"]) {
            NSMutableDictionary *friendInviteInfo = [NSMutableDictionary dictionaryWithDictionary:sourceDetailsInfo];
            friendInviteInfo[@"Id"] = info[@"Id"];
            friendInviteInfo[@"SourceId"] = info[@"SourceId"];
            notification = [Notification insertFriendInvitationNotification:friendInviteInfo];
            [result addObject:notification];
        } else if ([notificationType isEqualToString:@"ActivityInvite"]) {
            NSMutableDictionary *activityInviteInfo = [NSMutableDictionary dictionaryWithDictionary:sourceDetailsInfo];
            activityInviteInfo[@"Id"] = info[@"Id"];
            activityInviteInfo[@"SourceId"] = info[@"SourceId"];
            notification = [Notification insertActivityInvitationNotification:activityInviteInfo];
            [result addObject:notification];
        } else if ([notificationType isEqualToString:@"CourseInvite"]) {
            NSMutableDictionary *courseInviteInfo = [NSMutableDictionary dictionaryWithDictionary:sourceDetailsInfo];
            courseInviteInfo[@"Id"] = info[@"Id"];
            courseInviteInfo[@"SourceId"] = info[@"SourceId"];
            notification = [Notification insertCourseInvitationNotification:courseInviteInfo];
            [result addObject:notification];
        }
        WTLOG(@"Insert notification:%@", notification.sendTime);
    }
    return result;
}

+ (CourseInvitationNotification *)insertCourseInvitationNotification:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *notificationID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    CourseInvitationNotification *result = (CourseInvitationNotification *)[Notification notificationWithID:notificationID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInvitationNotification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = notificationID;
        result.objectClass = NSStringFromClass([CourseInvitationNotification class]);
    }
    
    result.updatedAt = [NSDate date];
    result.sourceID = [NSString stringWithFormat:@"%@", dict[@"SourceId"]];
    result.sendTime = [[NSString stringWithFormat:@"%@", dict[@"SentAt"]] convertToDate];
    result.sender = [User insertUser:dict[@"UserDetails"]];
    result.receiver = [User insertUser:dict[@"ToUserDetails"]];
    result.course = [Course insertCourse:dict[@"CourseDetails"]];
    [result.course setObjectHeldByHolder:[Notification class]];
    
    if ([[NSString stringWithFormat:@"%@", dict[@"AcceptedAt"]] isEqualToString:@"<null>"]) {
        result.accepted = @(NO);
    } else {
        result.accepted = @(YES);
    }
    
    return result;
}

+ (ActivityInvitationNotification *)insertActivityInvitationNotification:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *notificationID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    ActivityInvitationNotification *result = (ActivityInvitationNotification *)[Notification notificationWithID:notificationID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityInvitationNotification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = notificationID;
        result.objectClass = NSStringFromClass([ActivityInvitationNotification class]);
    }
    
    result.updatedAt = [NSDate date];
    result.sourceID = [NSString stringWithFormat:@"%@", dict[@"SourceId"]];
    result.sendTime = [[NSString stringWithFormat:@"%@", dict[@"SentAt"]] convertToDate];
    result.sender = [User insertUser:dict[@"UserDetails"]];
    result.receiver = [User insertUser:dict[@"ToUserDetails"]];
    result.activity = [Activity insertActivity:dict[@"ActivityDetails"]];
    [result.activity setObjectHeldByHolder:[Notification class]];
    
    if ([[NSString stringWithFormat:@"%@", dict[@"AcceptedAt"]] isEqualToString:@"<null>"]) {
        result.accepted = @(NO);
    } else {
        result.accepted = @(YES);
    }
    
    return result;
}

+ (FriendInvitationNotification *)insertFriendInvitationNotification:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *notificationID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    FriendInvitationNotification *result = (FriendInvitationNotification *)[Notification notificationWithID:notificationID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"FriendInvitationNotification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = notificationID;
        result.objectClass = NSStringFromClass([FriendInvitationNotification class]);
    }
    
    result.updatedAt = [NSDate date];
    result.sourceID = [NSString stringWithFormat:@"%@", dict[@"SourceId"]];
    result.sendTime = [[NSString stringWithFormat:@"%@", dict[@"SentAt"]] convertToDate];
    result.sender = [User insertUser:dict[@"UserDetails"]];
    result.receiver = [User insertUser:dict[@"ToUserDetails"]];
    
    if ([[NSString stringWithFormat:@"%@", dict[@"AcceptedAt"]] isEqualToString:@"<null>"]) {
        result.accepted = @(NO);
    } else {
        result.accepted = @(YES);
    }
    
    return result;
}

+ (Notification *)notificationWithID:(NSString *)notificationID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", notificationID]];
    
    Notification *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (void)deleteNotificationWithID:(NSString *)notificationID {
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", notificationID];
    [fetchRequest setPredicate:predicate];
    
    NSArray *items = [context executeFetchRequest:fetchRequest error:NULL];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
}

- (NSString *)customCellClassName {
    if ([self isMemberOfClass:[FriendInvitationNotification class]]) {
        return @"WTNotificationFriendInvitationCell";
    } else if ([self isMemberOfClass:[ActivityInvitationNotification class]]) {
        return @"WTNotificationActivityInvitationCell";
    } else if ([self isMemberOfClass:[CourseInvitationNotification class]]) {
        return @"WTNotificationCourseInvitationCell";
    } else {
        return nil;
    }
}

- (CGFloat)cellHeight {
    if ([self isKindOfClass:[InvitationNotification class]]) {
        InvitationNotification *invitation = (InvitationNotification *)self;
        return [WTNotificationInvitationCell cellHeightWithNotificationObject:invitation];
    } else {
        return 0;
    }
}

+ (void)clearOutdatedNotifications {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"updatedAt < %@", [NSDate dateWithTimeIntervalSinceNow:-1]]];
    NSArray *allNotifications = [context executeFetchRequest:request error:NULL];
    
    for(Notification *item in allNotifications) {
        WTLOG(@"Clear notification:%@", item.sendTime);
        if ([item isKindOfClass:[ActivityInvitationNotification class]]) {
            ActivityInvitationNotification *activityInvitation = (ActivityInvitationNotification *)item;
            [activityInvitation.activity removeRelatedActivityInvitationsObject:activityInvitation];
            if (activityInvitation.activity.relatedActivityInvitations.count == 0)
                [activityInvitation.activity setObjectFreeFromHolder:[Notification class]];
        } else if ([item isKindOfClass:[CourseInvitationNotification class]]) {
            CourseInvitationNotification *courseInvitation = (CourseInvitationNotification *)item;
            [courseInvitation.course removeRelatedCourseInvitationsObject:courseInvitation];
            if (courseInvitation.course.relatedCourseInvitations.count == 0)
                [courseInvitation.course setObjectFreeFromHolder:[Notification class]];
        }
        [context deleteObject:item];
    }
}

@end
