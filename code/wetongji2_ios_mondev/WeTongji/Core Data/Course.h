//
//  Course.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LikeableObject.h"

@class CourseInstance, CourseInvitationNotification, CourseTimetable, User;

@interface Course : LikeableObject

@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * courseNo;
@property (nonatomic, retain) NSNumber * credit;
@property (nonatomic, retain) NSNumber * friendsCount;
@property (nonatomic, retain) NSNumber * hours;
@property (nonatomic, retain) NSNumber * isAudit;
@property (nonatomic, retain) NSString * required;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * semester;
@property (nonatomic, retain) NSString * yearSemesterString;
@property (nonatomic, retain) NSSet *instances;
@property (nonatomic, retain) NSSet *registeredBy;
@property (nonatomic, retain) NSSet *relatedCourseInvitations;
@property (nonatomic, retain) NSSet *timetables;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addInstancesObject:(CourseInstance *)value;
- (void)removeInstancesObject:(CourseInstance *)value;
- (void)addInstances:(NSSet *)values;
- (void)removeInstances:(NSSet *)values;

- (void)addRegisteredByObject:(User *)value;
- (void)removeRegisteredByObject:(User *)value;
- (void)addRegisteredBy:(NSSet *)values;
- (void)removeRegisteredBy:(NSSet *)values;

- (void)addRelatedCourseInvitationsObject:(CourseInvitationNotification *)value;
- (void)removeRelatedCourseInvitationsObject:(CourseInvitationNotification *)value;
- (void)addRelatedCourseInvitations:(NSSet *)values;
- (void)removeRelatedCourseInvitations:(NSSet *)values;

- (void)addTimetablesObject:(CourseTimetable *)value;
- (void)removeTimetablesObject:(CourseTimetable *)value;
- (void)addTimetables:(NSSet *)values;
- (void)removeTimetables:(NSSet *)values;

@end
