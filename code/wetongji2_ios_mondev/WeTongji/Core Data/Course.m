//
//  Course.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-6.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course.h"
#import "CourseInstance.h"
#import "CourseInvitationNotification.h"
#import "CourseTimetable.h"
#import "User.h"
@implementation Course

@dynamic courseName;
@dynamic courseNo;
@dynamic credit;
@dynamic friendsCount;
@dynamic hours;
@dynamic isAudit;
@dynamic required;
@dynamic teacher;
@dynamic year;
@dynamic semester;
@dynamic yearSemesterString;
@dynamic instances;
@dynamic registeredBy;
@dynamic relatedCourseInvitations;
@dynamic timetables;

@end
