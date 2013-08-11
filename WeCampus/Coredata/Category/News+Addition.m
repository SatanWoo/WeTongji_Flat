//
//  News+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "News+Addition.h"
#import "Object+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"
#import "Organization+Addition.h"
#import "LikeableObject+Addition.h"

@implementation News (Addition)

+ (News *)insertNews:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *newsID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    News *result = [News newsWithID:newsID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = newsID;
        result.objectClass = NSStringFromClass([News class]);
    }
    
    result.updatedAt = [NSDate date];
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.content = [[NSString stringWithFormat:@"%@", dict[@"Context"]] clearAllBacklashR];
    result.summary = [NSString stringWithFormat:@"%@", dict[@"Summary"]];
    result.publishDate = [[NSString stringWithFormat:@"%@", [dict objectForKey:@"CreatedAt"]] convertToDate];
    result.readCount = @([[NSString stringWithFormat:@"%@", dict[@"Read"]] integerValue]);
    result.source = [NSString stringWithFormat:@"%@", dict[@"Source"]];
    
    result.hasTicket = @([[NSString stringWithFormat:@"%@", dict[@"HasTicket"]] boolValue]);
    result.phoneNumber = [NSString stringWithFormat:@"%@", dict[@"Contact"]];
    if ([result.phoneNumber isEqualToString:@""])
        result.phoneNumber = nil;
    
    result.ticketInfo = [NSString stringWithFormat:@"%@", dict[@"TicketService"]];
    result.location = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    
    NSArray *imageArray = dict[@"Images"];
    if (imageArray.count == 0)
        result.imageArray = nil;
    else
        result.imageArray = imageArray;
    
    NSString *categoryString = [NSString stringWithFormat:@"%@", dict[@"Category"]];
    if ([categoryString isEqualToString:@"校园新闻"])
        result.category = @(NewsShowTypeCampusUpdate);
    else if ([categoryString isEqualToString:@"社团通告"])
        result.category = @(NewsShowTypeClubNews);
    else if ([categoryString isEqualToString:@"周边推荐"])
        result.category = @(NewsShowTypeLocalRecommandation);
    else if ([categoryString isEqualToString:@"校务信息"])
        result.category = @(NewsShowTypeAdministrativeAffairs);
    else {
        NSAssert(NO, @"Error");
    }
    
    [result configureLikeInfo:dict];
    
    result.publishDay = [result.publishDate convertToYearMonthDayString];
    
    result.author = [Organization insertOrganization:dict[@"AccountDetails"]];
    
    return result;
}

+ (News *)newsWithID:(NSString *)newsID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", newsID]];
    
    News *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;
}

+ (void)setOutdatedNewsFreeFromHolder:(Class)holderClass
                           inCategory:(NSNumber *)category {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    [request setEntity:[NSEntityDescription entityForName:@"News" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"category == %@ AND updatedAt < %@", category, [NSDate dateWithTimeIntervalSinceNow:-1]]];
    NSArray *allNews = [context executeFetchRequest:request error:NULL];
    
    for(News *item in allNews) {
        [item setObjectFreeFromHolder:holderClass];
    }
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    self.publishDay = [self.publishDate convertToYearMonthDayString];
}

- (NSString *)yearMonthDayTimePublishTimeString {
    return [self.publishDate convertToYearMonthDayTimeString];
}

- (NSString *)categoryString {
    return [News convertCategoryStringFromCategory:self.category];
}
+ (NSString *)convertCategoryStringFromCategory:(NSNumber *)category {
    switch (category.integerValue) {
        case NewsShowTypeCampusUpdate:
            return NSLocalizedString(@"Campus Update", nil);
        case NewsShowTypeClubNews:
            return NSLocalizedString(@"Club News", nil);
        case NewsShowTypeLocalRecommandation:
            return NSLocalizedString(@"Local Recommendation", nil);
        case NewsShowTypeAdministrativeAffairs:
            return NSLocalizedString(@"Administrative Affairs", nil);
        case NewsShowTypeMyCollege:
            return NSLocalizedString(@"My College", nil);
        default:
            break;
    }
    return nil;
}

@end
