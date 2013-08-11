//
//  User+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "User+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"
#import "LikeableObject+Addition.h"

@implementation User (Addition)

+ (User *)insertUser:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"UID"]) {
        return nil;
    }
    
    NSString *userID = [NSString stringWithFormat:@"%@", dict[@"UID"]];
    
    User *result = [User userWithID:userID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        
        result.identifier = userID;
        result.objectClass = NSStringFromClass([User class]);
    }
    
    result.updatedAt = [NSDate date];
    result.avatar = [NSString stringWithFormat:@"%@", dict[@"Avatar"]];
    result.birthday = [[NSString stringWithFormat:@"%@", dict[@"Birthday"]] convertToDate];
    result.department = [NSString stringWithFormat:@"%@", dict[@"Department"]];
    result.name = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.gender = [NSString stringWithFormat:@"%@", dict[@"Gender"]];
    result.major = [NSString stringWithFormat:@"%@", dict[@"Major"]];
    result.studentNumber = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    result.studyPlan = @([[NSString stringWithFormat:@"%@", dict[@"Plan"]] integerValue]);
    result.enrollYear = @([[NSString stringWithFormat:@"%@", dict[@"Year"]] integerValue]);
    result.motto = [NSString stringWithFormat:@"%@", dict[@"Words"]];
    if ([result.motto isEqualToString:@"<null>"] || [result.motto isEqualToString:@"(null)"]) {
        result.motto = @"";
    }
    
    result.emailAddress = [NSString stringWithFormat:@"%@", dict[@"Email"]];
    if ([result.emailAddress isEqualToString:@"<null>"]) {
        result.emailAddress = @"";
    }
    
    result.phoneNumber = [NSString stringWithFormat:@"%@", dict[@"Phone"]];
    if ([result.phoneNumber isEqualToString:@"<null>"]) {
        result.phoneNumber = @"";
    }
    
    result.sinaWeiboName = [NSString stringWithFormat:@"%@", dict[@"SinaWeibo"]];
    if ([result.sinaWeiboName isEqualToString:@"<null>"]) {
        result.sinaWeiboName = @"";
    }
    
    result.qqAccount = [NSString stringWithFormat:@"%@", dict[@"QQ"]];
    if ([result.qqAccount isEqualToString:@"<null>"]) {
        result.qqAccount = @"";
    }
    
    NSString *dormString = [NSString stringWithFormat:@"%@", dict[@"Room"]];
    NSArray *dormComponentArray = [dormString componentsSeparatedByString:@" "];
    if (dormComponentArray.count != 3) {
        result.dormDistribute = @"";
        result.dormBuilding = @"";
        result.dormRoom = @"";
    } else {
        result.dormDistribute = dormComponentArray[0];
        result.dormBuilding = dormComponentArray[1];
        result.dormRoom = dormComponentArray[2];
    }
    
    BOOL isCurrentUserFriend = [[NSString stringWithFormat:@"%@", dict[@"IsFriend"]] boolValue];
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (isCurrentUserFriend) {
        [currentUser addFriendsObject:result];
    } else {
        [currentUser removeFriendsObject:result];
    }
    
    NSDictionary *likedCountInfo = dict[@"LikeCount"];
    result.likedActivityCount = @([[NSString stringWithFormat:@"%@", likedCountInfo[@"Activity"]] integerValue]);
    result.likedBillboardCount = @([[NSString stringWithFormat:@"%@", likedCountInfo[@"Story"]] integerValue]);
    result.likedNewsCount = @([[NSString stringWithFormat:@"%@", likedCountInfo[@"Information"]] integerValue]);
    result.likedOrganizationCount = @([[NSString stringWithFormat:@"%@", likedCountInfo[@"Account"]] integerValue]);
    result.likedStarCount = @([[NSString stringWithFormat:@"%@", likedCountInfo[@"Person"]] integerValue]);
    result.likedUserCount = @([[NSString stringWithFormat:@"%@", likedCountInfo[@"User"]] integerValue]);
    
    result.friendCount = @([[NSString stringWithFormat:@"%@", dict[@"FriendCount"]] integerValue]);
    NSDictionary *scheduleCountInfo = dict[@"ScheduleCount"];
    result.scheduledActivityCount = @([[NSString stringWithFormat:@"%@", scheduleCountInfo[@"Activity"]] integerValue]);
    result.scheduledCourseCount = @([[NSString stringWithFormat:@"%@", scheduleCountInfo[@"Course"]] integerValue]);
    
    [result configureLikeInfo:dict];
    
    return result;
}

+ (User *)userWithID:(NSString *)userID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", userID]];
    
    User *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

#pragma mark - Properties

- (NSString *)dormString {
    if (self.dormDistribute.length > 0 && self.dormBuilding.length > 0 && self.dormRoom.length > 0)
        return [NSString stringWithFormat:@"%@ %@ %@", self.dormDistribute, self.dormBuilding, self.dormRoom];
    else
        return @"";
}

@end
