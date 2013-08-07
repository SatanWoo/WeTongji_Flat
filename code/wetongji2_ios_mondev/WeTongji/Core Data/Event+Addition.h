//
//  Event+Addition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Event.h"

@interface Event (Addition)

@property (nonatomic, readonly) NSString *yearMonthDayBeginToEndTimeString;
@property (nonatomic, readonly) NSString *beginToEndTimeString;

@property (nonatomic, assign) BOOL scheduledByCurrentUser;

+ (NSArray *)getTodayEvents;

+ (void)setCurrentUserScheduledEventsFreeFromHolder:(Class)holderClass
                                           fromDate:(NSDate *)beginDate
                                             toDate:(NSDate *)endDate;

- (void)configureScheduleInfo:(NSDictionary *)infoDict;

@end
