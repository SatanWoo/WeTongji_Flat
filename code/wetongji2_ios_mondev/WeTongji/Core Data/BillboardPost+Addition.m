//
//  BillboardPost+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "BillboardPost+Addition.h"
#import "WTCoreDataManager.h"
#import "User+Addition.h"
#import "NSString+WTAddition.h"
#import "LikeableObject+Addition.h"

@implementation BillboardPost (Addition)

+ (BillboardPost *)insertBillboardPost:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *postID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    BillboardPost *result = [BillboardPost postWithID:postID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"BillboardPost" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = postID;
        result.objectClass = NSStringFromClass([BillboardPost class]);
    }
    
    result.updatedAt = [NSDate date];
    if ([[NSString stringWithFormat:@"%@", dict[@"Title"]] length] > 0)
        result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.image = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    if ([result.image isEmptyImageURL])
        result.image = nil;
    
    if (result.image == nil && [[NSString stringWithFormat:@"%@", dict[@"Body"]] length] > 0) {
        result.content = [NSString stringWithFormat:@"%@", dict[@"Body"]];
    }
    
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"PublishedAt"]] convertToDate];
    result.commentCount = @(((NSString *)[NSString stringWithFormat:@"%@", dict[@"CommentsCount"]]).integerValue);
    
    User *user = [User insertUser:dict[@"UserDetails"]];
    result.author = user;
    
    [result configureLikeInfo:dict];
    
    return result;
}

+ (BillboardPost *)postWithID:(NSString *)postID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"BillboardPost" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", postID]];
    
    BillboardPost *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

@end
