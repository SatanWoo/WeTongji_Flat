//
//  Organization+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Organization+Addition.h"
#import "WTCoreDataManager.h"
#import "LikeableObject+Addition.h"
#import "NSString+WTAddition.h"

@implementation Organization (Addition)

+ (Organization *)insertOrganization:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *orgID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    Organization *result = [Organization organizationWithID:orgID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = orgID;
        result.objectClass = NSStringFromClass([Organization class]);
    }
    
    result.updatedAt = [NSDate date];
    result.avatar = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    result.bgImage = [NSString stringWithFormat:@"%@", dict[@"Background"]];
    result.name = [NSString stringWithFormat:@"%@", dict[@"Display"]];
    result.administrator = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.about = [[NSString stringWithFormat:@"%@", dict[@"Description"]] clearAllBacklashR];
    if ([result.about isEqualToString:@"<null>"]) {
        result.about = nil;
    }
    
    result.email = [NSString stringWithFormat:@"%@", dict[@"Email"]];
    result.administrator = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.adminTitle = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    
    result.activityCount = @([[NSString stringWithFormat:@"%@", dict[@"ActivitiesCount"]] integerValue]);
    result.newsCount = @([[NSString stringWithFormat:@"%@", dict[@"InformationCount"]] integerValue]);
    
    [result configureLikeInfo:dict];
        
    return result;
}

+ (Organization *)organizationWithID:(NSString *)orgID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Organization" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", orgID]];
    
    Organization *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
