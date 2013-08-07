//
//  News+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-14.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "News.h"
#import "NSUserDefaults+WTAddition.h"

@interface News (Addition)

@property (nonatomic, readonly) NSString *yearMonthDayTimePublishTimeString;

@property (nonatomic, readonly) NSString *categoryString;

+ (News *)insertNews:(NSDictionary *)dict;

+ (News *)newsWithID:(NSString *)newsID;

+ (void)setOutdatedNewsFreeFromHolder:(Class)holderClass
                           inCategory:(NSNumber *)category;

+ (NSString *)convertCategoryStringFromCategory:(NSNumber *)category;

@end
