//
//  Activity+Addition.h
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "Activity.h"
#import "Event+Addition.h"
#import "NSUserDefaults+WTAddition.h"

@interface Activity (Addition)

@property (nonatomic, readonly) NSString *categoryString;

+ (Activity *)insertActivity:(NSDictionary *)dict;

+ (Activity *)activityWithID:(NSString *)activityID;

+ (void)setOutdatedActivitesFreeFromHolder:(Class)holderClass
                                inCategory:(NSNumber *)category;

+ (NSString *)convertCategoryStringFromCategory:(NSNumber *)category;

@end
