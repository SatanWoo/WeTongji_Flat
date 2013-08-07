//
//  Advertisement+Addition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-17.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Advertisement+Addition.h"
#import "WTCoreDataManager.h"

@implementation Advertisement (Addition)

+ (Advertisement *)insertAdvertisement:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"Id"]) {
        return nil;
    }
    
    NSString *adID = [NSString stringWithFormat:@"%@", dict[@"Id"]];
    
    Advertisement *result = [Advertisement advertisementWithID:adID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Advertisement" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = adID;
        result.objectClass = NSStringFromClass([Advertisement class]);
    }
    
    result.updatedAt = [NSDate date];
    result.title = [NSString stringWithFormat:@"%@", dict[@"Title"]];
    result.image = [NSString stringWithFormat:@"%@", dict[@"Image"]];
    result.publisher = [NSString stringWithFormat:@"%@", dict[@"Publisher"]];
    result.bgColorHex = [NSString stringWithFormat:@"%@", dict[@"BgColor"]];
    result.website = [NSString stringWithFormat:@"%@", dict[@"URL"]];
    
    return result;
}

+ (Advertisement *)advertisementWithID:(NSString *)adID {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Advertisement" inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", adID]];
    
    Advertisement *result = [[[WTCoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:NULL] lastObject];
    
    return result;

}

@end
