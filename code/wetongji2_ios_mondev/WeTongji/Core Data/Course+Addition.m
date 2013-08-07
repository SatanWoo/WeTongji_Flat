//
//  CourseInstance+Addition.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-7.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course+Addition.h"
#import "NSString+WTAddition.h"
#import "WTCoreDataManager.h"
#import "LikeableObject+Addition.h"
#import "Event+Addition.h"

@implementation CourseInstance (Addition)

+ (CourseInstance *)insertCourseInstance:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    Course *course = [Course insertCourse:dict[@"CourseDetails"]];
    if (!course)
        return nil;
    
    NSString *courseID = course.identifier;
    
    NSDate *courseDay = [[NSString stringWithFormat:@"%@", dict[@"Day"]] convertToDate];
    NSInteger sectionStart = [[NSString stringWithFormat:@"%@", dict[@"SectionStart"]] integerValue];
    NSInteger sectionEnd = [[NSString stringWithFormat:@"%@", dict[@"SectionEnd"]] integerValue];
    NSDate *beginTime = [courseDay dateByAddingTimeInterval:
                         [CourseInstance getDayTimeIntervalFromSection:sectionStart]];
    NSDate *endTime = [courseDay dateByAddingTimeInterval:
                       [CourseInstance getDayTimeIntervalFromSection:sectionEnd]];
    
    
    CourseInstance *result = [CourseInstance courseInstanceWithCourseID:courseID beginTime:beginTime];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"CourseInstance"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = courseID;
        result.objectClass = NSStringFromClass([CourseInstance class]);
    }

    result.updatedAt = [NSDate date];
    
    result.course = course;
    result.beginTime = beginTime;
    result.endTime = endTime;
    
    result.what = course.courseName;
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.friendsCount = course.friendsCount;
    
    result.beginDay = [result.beginTime convertToYearMonthDayString];

    [result configureLikeInfo:dict];
    // [result configureScheduleInfo:dict];
    
    return result;
}

+ (CourseInstance *)courseInstanceWithCourseID:(NSString *)courseID
                                     beginTime:(NSDate *)beginTime {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CourseInstance"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@ AND beginTime == %@", courseID, beginTime];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    return [matches lastObject];
}

+ (NSTimeInterval)getDayTimeIntervalFromSection:(NSInteger)section {
    NSTimeInterval result = 0;
    switch (section) {
        case 1:
            result = 8 * HOUR_TIME_INTERVAL;
            break;
        case 2:
            result = 9 * HOUR_TIME_INTERVAL + 40 * MINUTE_TIME_INTERVAL;
            break;
        case 3:
            result = 10 * HOUR_TIME_INTERVAL;
            break;
        case 4:
            result = 11 * HOUR_TIME_INTERVAL + 40 * MINUTE_TIME_INTERVAL;
            break;
        case 5:
            result = 13 * HOUR_TIME_INTERVAL + 30 * MINUTE_TIME_INTERVAL;
            break;
        case 6:
            result = 15 * HOUR_TIME_INTERVAL + 5 * MINUTE_TIME_INTERVAL;
            break;
        case 7:
            result = 15 * HOUR_TIME_INTERVAL + 25 * MINUTE_TIME_INTERVAL;
            break;
        case 8:
            result = 17 * HOUR_TIME_INTERVAL;
            break;
        case 9:
            result = 18 * HOUR_TIME_INTERVAL + 30 * MINUTE_TIME_INTERVAL;
            break;
        case 10:
            result = 20 * HOUR_TIME_INTERVAL + 10 * MINUTE_TIME_INTERVAL;
            break;
        case 11:
            result = 21 * HOUR_TIME_INTERVAL + 5 * MINUTE_TIME_INTERVAL;
            break;
        default:
            break;
    }
    return result;
}

@end

@implementation Course (Addition)

- (BOOL)registeredByCurrentUser {
    return [[WTCoreDataManager sharedManager].currentUser.registeredCourses containsObject:self];
}

- (void)setRegisteredByCurrentUser:(BOOL)registeredByCurrentUser {
    User *currentUser = [WTCoreDataManager sharedManager].currentUser;
    if (self.registeredByCurrentUser != registeredByCurrentUser) {
        if (registeredByCurrentUser) {
            [currentUser addRegisteredCoursesObject:self];
            for (CourseInstance *instance in self.instances) {
                instance.scheduledByCurrentUser = YES;
            }
        } else {
            [currentUser removeRegisteredCoursesObject:self];
            for (CourseInstance *instance in self.instances) {
                instance.scheduledByCurrentUser = NO;
            }
        }
    }
}

- (NSArray *)timetableArray {
    NSArray *timetableArray = [self.timetables sortedArrayUsingDescriptors:@[
                               [NSSortDescriptor sortDescriptorWithKey:@"weekDay" ascending:YES],
                               [NSSortDescriptor sortDescriptorWithKey:@"startSection" ascending:YES]
                               ]];
    return timetableArray;
}

- (NSString *)timetableString {
    NSMutableString *result = [NSMutableString string];
    NSArray *timetableArray = self.timetableArray;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    for (int i = 0; i < timetableArray.count; i++) {
        if (i != 0) {
            [result appendString:@", "];
        }
        
        CourseTimetable *timetable = timetableArray[i];
        [result appendFormat:@"%@(%@) %d-%d%@ %@",
         [NSString weekStringConvertFromInteger:timetable.weekDay.integerValue],
         timetable.weekType,
         timetable.startSection.integerValue,
         timetable.endSection.integerValue,
         [language isEqualToString:@"zh-Hans"] ? @"节" : @"",
        timetable.location];
    }
    
    return result;
}

+ (Course *)insertCourse:(NSDictionary *)dict {
    NSString *courseID = [NSString stringWithFormat:@"%@", dict[@"UNO"]];
    
    if ([courseID isEqualToString:@"(null)"]) {
        return nil;
    }
    
    Course *result = [Course courseWithCourseID:courseID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Course"
                                               inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = courseID;
        result.objectClass = NSStringFromClass([Course class]);
    }
    
    result.updatedAt = [NSDate date];
    
    result.teacher = [NSString stringWithFormat:@"%@", dict[@"Teacher"]];
    result.hours = @([[NSString stringWithFormat:@"%@", dict[@"Hours"]] integerValue]);
    result.credit = @([[NSString stringWithFormat:@"%@", dict[@"Point"]] floatValue]);
    result.required = [NSString stringWithFormat:@"%@", dict[@"Required"]];
    result.courseNo = [NSString stringWithFormat:@"%@", dict[@"NO"]];
    result.courseName = [NSString stringWithFormat:@"%@", dict[@"Name"]];
    result.friendsCount = @([[NSString stringWithFormat:@"%@", dict[@"FriendsCount"]] integerValue]);
    
    BOOL canSchedule = [[NSString stringWithFormat:@"%@", dict[@"CanSchedule"]] boolValue];
    result.registeredByCurrentUser = !canSchedule;
    
    result.isAudit = @([[NSString stringWithFormat:@"%@", dict[@"IsAudit"]] boolValue]);
    
    result.year = @([[courseID substringToIndex:2] integerValue]);
    result.semester = @([[courseID substringWithRange:NSMakeRange(2, 2)] integerValue]);
    [result generateYearSemesterString];
    
    if (result.timetables.count == 0) {
        NSArray *courseTimetableDictArray = dict[@"Sections"];
        for (NSDictionary *timetableDict in courseTimetableDictArray) {
            CourseTimetable *timetable = [CourseTimetable insertCourseTimetable:timetableDict];
            if (timetable) {
                [result addTimetablesObject:timetable];
                timetable.identifier = result.identifier;
            }
        }
    }
    
    return result;
}

+ (Course *)courseWithCourseID:(NSString *)courseID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", courseID];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    return [matches lastObject];
}

- (void)generateYearSemesterString {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    BOOL isInFirstHalfYear = (self.semester.integerValue == 1);
    NSInteger beginYear = isInFirstHalfYear ? self.year.integerValue - 1 : self.year.integerValue;
    NSInteger endYear = beginYear + 1;
    if ([language isEqualToString:@"zh-Hans"]) {
        self.yearSemesterString = [NSString stringWithFormat:@"20%d年-20%d年 第%@学期", beginYear, endYear, isInFirstHalfYear ? @"二" : @"一"];
    } else {
        self.yearSemesterString = [NSString stringWithFormat:@"20%d-20%d Semester %d", beginYear, endYear, isInFirstHalfYear ? 2 : 1];
    }
}

- (void)awakeFromFetch {
    [super awakeFromFetch];
    [self generateYearSemesterString];
}

@end

@implementation CourseTimetable (Addition)

- (NSString *)timeString {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    return [NSString stringWithFormat:@"%@ %d-%d%@",
            [NSString weekStringConvertFromInteger:self.weekDay.integerValue],
            self.startSection.integerValue,
            self.endSection.integerValue,
            [language isEqualToString:@"zh-Hans"] ? @"节" : @""];
}

+ (CourseTimetable *)insertCourseTimetable:(NSDictionary *)dict {
    if (!dict || dict.count == 0)
        return nil;
    CourseTimetable *result = [NSEntityDescription insertNewObjectForEntityForName:@"CourseTimetable"
                                                            inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
    
    result.startSection = @([[NSString stringWithFormat:@"%@", dict[@"SectionStart"]] integerValue]);
    result.endSection = @([[NSString stringWithFormat:@"%@", dict[@"SectionEnd"]] integerValue]);
    result.weekType = [NSString stringWithFormat:@"%@", dict[@"WeekType"]];
    NSString *weekDayString = [NSString stringWithFormat:@"%@", dict[@"WeekDay"]];
    [result configureWeekDayWithString:weekDayString];
    result.location = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    
    return result;
}

- (void)configureWeekDayWithString:(NSString *)weekDayString {
    if ([weekDayString isEqualToString:@"星期一"]) {
        self.weekDay = @(2);
    } else if ([weekDayString isEqualToString:@"星期二"]) {
        self.weekDay = @(3);
    } else if ([weekDayString isEqualToString:@"星期三"]) {
        self.weekDay = @(4);
    } else if ([weekDayString isEqualToString:@"星期四"]) {
        self.weekDay = @(5);
    } else if ([weekDayString isEqualToString:@"星期五"]) {
        self.weekDay = @(6);
    } else if ([weekDayString isEqualToString:@"星期六"]) {
        self.weekDay = @(7);
    } else if ([weekDayString isEqualToString:@"星期日"]) {
        self.weekDay = @(1);
    }
}

@end
