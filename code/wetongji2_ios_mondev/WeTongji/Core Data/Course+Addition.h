//
//  Course+Addition.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course.h"
#import "CourseInstance.h"
#import "CourseTimetable.h"
#import "Event+Addition.h"

@interface CourseInstance (Addition)

+ (CourseInstance *)insertCourseInstance:(NSDictionary *)dict;

+ (CourseInstance *)courseInstanceWithCourseID:(NSString *)courseID
                                     beginTime:(NSDate *)beginTime;

@end

@interface Course (Addition)

@property (nonatomic, assign) BOOL registeredByCurrentUser;

@property (nonatomic, readonly) NSArray *timetableArray;

@property (nonatomic, readonly) NSString *timetableString;

+ (Course *)insertCourse:(NSDictionary *)dict;

+ (Course *)courseWithCourseID:(NSString *)courseID;

@end

@interface CourseTimetable (Addition)

@property (nonatomic, readonly) NSString *timeString;

+ (CourseTimetable *)insertCourseTimetable:(NSDictionary *)dict;

@end
