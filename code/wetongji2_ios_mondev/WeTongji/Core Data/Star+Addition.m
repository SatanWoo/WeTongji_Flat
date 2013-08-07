//
//  Star+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Star+Addition.h"
#import "WTCoreDataManager.h"
#import "Object+Addition.h"
#import "NSString+WTAddition.h"
#import "LikeableObject+Addition.h"

@implementation Star (Addition)

+ (Star *)insertStar:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *starID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    Star *result = [Star starWithID:starID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Star" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = starID;
        result.objectClass = NSStringFromClass([Star class]);
    }
    
    result.updatedAt = [NSDate date];
    result.avatar = [NSString stringWithFormat:@"%@", dict[@"Avatar"]];
    result.content = [[NSString stringWithFormat:@"%@", dict[@"Description"]] clearAllBacklashR];
    
    NSDictionary *imageInfoDict = dict[@"Images"];
    if (imageInfoDict.count == 0) {
        result.imageInfoDict = nil;
    } else {
        result.imageInfoDict = imageInfoDict;
    }

    result.jobTitle = [NSString stringWithFormat:@"%@", dict[@"JobTitle"]];
    result.studentNumber = [NSString stringWithFormat:@"%@", dict[@"StudentNO"]];
    result.name = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.motto = [NSString stringWithFormat:@"%@", dict[@"Words"]];
    result.volume = @([[NSString stringWithFormat:@"%@", dict[@"NO"]] integerValue]);
    result.createdAt = [[NSString stringWithFormat:@"%@", dict[@"CreatedAt"]] convertToDate];
    
    [result configureLikeInfo:dict];
    
    return result;
}

+ (Star *)starWithID:(NSString *)starID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Star" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", starID]];
    
    Star *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

- (NSArray *)imageDescriptionArray {
    NSMutableArray *imageDescriptionArray = [NSMutableArray array];
    NSDictionary *imageInfoDict = self.imageInfoDict;
    [imageInfoDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [imageDescriptionArray addObject:[NSString stringWithFormat:@"%@", obj]];
    }];
    return imageDescriptionArray;
}

- (NSArray *)imageURLStringArray {
    NSMutableArray *imageURLStringArray = [NSMutableArray array];
    NSDictionary *imageInfoDict = self.imageInfoDict;
    [imageInfoDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [imageURLStringArray addObject:[NSString stringWithFormat:@"%@", key]];
    }];
    return imageURLStringArray;
}

@end
