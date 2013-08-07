//
//  WTCourseTimetableView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;
@class CourseTimetable;

@interface WTCourseTimetableContainerView : UIView

+ (WTCourseTimetableContainerView *)createViewWithCourse:(Course *)course;

@end

@interface WTCourseTimetableItemView : UIView

+ (WTCourseTimetableItemView *)createViewWithCourseTimetable:(CourseTimetable *)timetable;

@end
