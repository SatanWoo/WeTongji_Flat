//
//  WTNowConfigLoader.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowConfigLoader.h"
#import "WTConfigLoader.h"
#import "NSString+WTAddition.h"
#import "Course+Addition.h"

#define kSectionType    @"SectionType"
#define kSectionStartAt @"SectionStartAt"
#define kSchoolYear     @"SchoolYear"
#define kSchoolSemester @"SchoolSemester"
#define kVacationType   @"VacationType"
#define kWeekCount      @"WeekCount"

@interface WTNowConfigLoader ()

@property (nonatomic, strong) NSArray *sectionInfoArray;

@end

@implementation WTNowConfigLoader

+ (WTNowConfigLoader *)sharedLoader {
    static WTNowConfigLoader *loader = nil;
    static dispatch_once_t WTNowConfigLoaderPredicate;
    dispatch_once(&WTNowConfigLoaderPredicate, ^{
        loader = [[WTNowConfigLoader alloc] init];
    });
    
    return loader;
}

- (id)init {
    self = [super init];
    if (self) {
        self.sectionInfoArray = [[WTConfigLoader sharedLoader] loadConfig:@"WTNowConfig"];
        
        NSDictionary *firstSectionInfo = self.sectionInfoArray[0];
        NSDictionary *lastSectionInfo = self.sectionInfoArray.lastObject;
        NSDate *startDate = [firstSectionInfo[kSectionStartAt] convertToDate];
        self.baseStartDate = startDate;
        
        NSDate *endDate = [lastSectionInfo[kSectionStartAt] convertToDate];
        self.currentSectionStartDate = endDate;
        
        if (lastSectionInfo[kWeekCount]) {
            endDate = [endDate dateByAddingTimeInterval:WEEK_TIME_INTERVAL * [lastSectionInfo[kWeekCount] integerValue]];
        }
        self.numberOfWeeks = ([endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]) / WEEK_TIME_INTERVAL;
    }
    return self;
}

- (BOOL)isCourseOutdated:(Course *)course {
    BOOL isInFirstHalfYear = (course.semester.integerValue == 1);
    NSInteger beginYear = isInFirstHalfYear ? course.year.integerValue - 1 : course.year.integerValue;
    NSInteger endYear = beginYear + 1;
    NSString *courseYearString = [NSString stringWithFormat:@"%d-%d", beginYear, endYear];
    NSString *courseSemesterString = [NSString stringWithFormat:@"%d", isInFirstHalfYear ? 2 : 1];
    
    NSDictionary *sectionInfo = [self getSectionInfoWithCourseYearString:courseYearString courseSemesterString:courseSemesterString];
    NSDate *sectionStartDate = [sectionInfo[kSectionStartAt] convertToDate];
    NSDate *sectionEndDate = [sectionStartDate dateByAddingTimeInterval:WEEK_TIME_INTERVAL * [sectionInfo[kWeekCount] integerValue]];
    if ([sectionEndDate compare:[NSDate date]] == NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (NSDictionary *)getSectionInfoWithCourseYearString:(NSString *)courseYearString
                                courseSemesterString:(NSString *)courseSemesterString {
    for (NSDictionary *sectionInfo in self.sectionInfoArray) {
        NSString *schoolYear = sectionInfo[kSchoolYear];
        NSString *schoolSemester = sectionInfo[kSchoolSemester];
        if ([schoolSemester isEqualToString:courseSemesterString] && [schoolYear isEqualToString:courseYearString]) {
            return sectionInfo;
        }
    }
    return nil;
}

- (NSDictionary *)getSectionInfoForWeek:(NSInteger)week {
    NSDictionary *resultSectionInfo = nil;
    NSDate *resultStartDate = [self.baseStartDate dateByAddingTimeInterval:(week - 1) * WEEK_TIME_INTERVAL];
    for (int i = self.sectionInfoArray.count - 1; i >= 0; i--) {
        NSDictionary *sectionInfo = self.sectionInfoArray[i];
        NSDate *sectionStartDate = [sectionInfo[kSectionStartAt] convertToDate];
        if ([sectionStartDate compare:resultStartDate] != NSOrderedDescending) {
            resultSectionInfo = sectionInfo;
            break;
        }
    }
    return resultSectionInfo;
}

- (NSString *)sectionNameForWeek:(NSInteger)week {
    NSDictionary *resultSectionInfo = [self getSectionInfoForWeek:week];
    NSString *resultName = nil;
    NSString *resultSectionType = resultSectionInfo[kSectionType];
    if ([resultSectionType isEqualToString:@"School"]) {
        NSString *schollYearString = resultSectionInfo[kSchoolYear];
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"zh-Hans"])
            schollYearString = [schollYearString stringByAppendingString:@"年"];

        NSInteger semester = [resultSectionInfo[kSchoolSemester] integerValue];
        NSString *semesterString = [NSString stringWithFormat:@"Semester %d", semester];
        if ([language isEqualToString:@"zh-Hans"])
            semesterString = [NSString stringWithFormat:@"第%@学期", semester == 1 ? @"一" : @"二"];
        
        resultName = [NSString stringWithFormat:@"%@ %@", schollYearString, semesterString];
    } else {
        NSDate *sectionStartDate = [resultSectionInfo[kSectionStartAt] convertToDate];
        resultName = [NSString stringWithFormat:@"%@ %@" , [sectionStartDate convertToYearString], NSLocalizedString(resultSectionInfo[kVacationType], nil)];
    }
    return resultName;
}

- (NSString *)relativeWeekNumberStringForWeek:(NSInteger)week {
    NSDictionary *resultSectionInfo = [self getSectionInfoForWeek:week];
    NSDate *resultStartDate = [resultSectionInfo[kSectionStartAt] convertToDate];
    NSInteger resultSectionRelativeWeekCount = ([resultStartDate timeIntervalSince1970] - [self.baseStartDate timeIntervalSince1970]) / WEEK_TIME_INTERVAL;
    return [NSString stringWithFormat:@"%d", week - resultSectionRelativeWeekCount];
}

@end
