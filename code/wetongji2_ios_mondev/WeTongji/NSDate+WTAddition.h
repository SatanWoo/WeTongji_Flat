//
//  NSDate+WTAddition.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-28.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WTAddition)

- (BOOL)isDateInToday;

- (NSString *)convertToYearString;

- (NSString *)convertToYearMonthDayString;

- (NSString *)convertToYearMonthDayWeekString;

- (NSString *)convertToYearMonthDayWeekTimeString;

- (NSString *)convertToWeekString;

- (NSString *)convertToYearMonthDayTimeString;

- (NSString *)convertToTimeString;

@end
