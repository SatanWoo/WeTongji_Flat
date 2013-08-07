//
//  Comment+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-28.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Comment+Addition.h"
#import "WTCoreDataManager.h"
#import "User+Addition.h"
#import "NSString+WTAddition.h"

@implementation Comment (Addition)

+ (Comment *)insertComment:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *commentID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    Comment *result = [Comment commmentWithID:commentID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = commentID;
        result.objectClass = NSStringFromClass([Comment class]);
    }
    
    result.updatedAt = [NSDate date];
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"PublishedAt"]] convertToDate];
    result.content = [NSString stringWithFormat:@"%@", dict[@"Body"]];
    
    User *user = [User insertUser:dict[@"UserDetails"]];
    result.author = user;
    
    return result;
}

+ (Comment *)commmentWithID:(NSString *)commentID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Comment" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", commentID]];
    
    Comment *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
