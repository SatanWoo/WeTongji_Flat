//
//  WTCourseInstanceHeaderView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseBaseHeaderView.h"

@class CourseInstance;

@interface WTCourseInstanceHeaderView : WTCourseBaseHeaderView

+ (WTCourseInstanceHeaderView *)createHeaderViewWithCourseInstance:(CourseInstance *)courseInstance;

@end
