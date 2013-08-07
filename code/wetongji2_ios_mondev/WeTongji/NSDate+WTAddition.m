//
//  NSDate+WTAddition.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-28.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "NSDate+WTAddition.h"
#import "NSString+WTAddition.h"

@implementation NSDate (WTAddition)

- (BOOL)isDateInToday {
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;
    NSDate *lastMidnight = [[NSCalendar currentCalendar] dateFromComponents:todayComponents];
    NSDate *nextMidnight = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:lastMidnight options:NSWrapCalendarComponents];
    return ([self compare:lastMidnight] == NSOrderedDescending && [self compare:nextMidnight] == NSOrderedAscending);
}

- (NSString *)convertToYearString {
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"zh-Hans"]) {
        [form setDateFormat:@"yyyy年"];
    } else {
        [form setDateFormat:@"yy"];
    }
    
    NSString *result = [form stringFromDate:self];
    return result;
}

- (NSString *)convertToYearMonthDayString {
    if ([self isDateInToday]) {
        return NSLocalizedString(@"Today", nil);
    }
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"zh-Hans"]) {
        [form setDateFormat:@"yyyy年M月d日"];
    } else {
       [form setDateFormat:@"M/d/yyyy"];
    }
    
    NSString *result = [form stringFromDate:self];
    return result;
}

- (NSString *)convertToYearMonthDayWeekString {
    if ([self isDateInToday]) {
        return NSLocalizedString(@"Today", nil);
    }
    NSString *result = [self convertToYearMonthDayString];
    result = [NSString stringWithFormat:@"%@ %@", result, [self convertToWeekString]];
    return result;
}

- (NSString *)convertToYearMonthDayWeekTimeString {
    NSString *result = [self convertToYearMonthDayWeekString];
    result = [NSString stringWithFormat:@"%@ %@", result, [self convertToTimeString]];
    return result;
}

- (NSString *)convertToWeekString {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:self];
    NSInteger weekday = [comps weekday];
    
    return [NSString weekStringConvertFromInteger:weekday];
}

- (NSString *)convertToYearMonthDayTimeString {
    NSString *result = [self convertToYearMonthDayString];
    result = [NSString stringWithFormat:@"%@ %@", result, [self convertToTimeString]];
    return result;
}

- (NSString *)convertToTimeString {
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"HH:mm"];
    NSString *result = [form stringFromDate:self];
    return result;
}

@end
