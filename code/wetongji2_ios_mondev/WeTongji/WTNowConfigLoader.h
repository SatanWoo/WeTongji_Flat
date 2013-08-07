//
//  WTNowConfigLoader.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-23.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Course;

@interface WTNowConfigLoader : NSObject

@property (nonatomic, assign) NSInteger numberOfWeeks;

@property (nonatomic, strong) NSDate *baseStartDate;

@property (nonatomic, strong) NSDate *currentSectionStartDate;

+ (WTNowConfigLoader *)sharedLoader;

- (BOOL)isCourseOutdated:(Course *)course;

- (NSString *)sectionNameForWeek:(NSInteger)week;

- (NSString *)relativeWeekNumberStringForWeek:(NSInteger)week;

@end
