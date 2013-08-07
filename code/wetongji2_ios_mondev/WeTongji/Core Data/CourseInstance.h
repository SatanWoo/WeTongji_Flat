//
//  CourseInstance.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Course;

@interface CourseInstance : Event

@property (nonatomic, retain) Course *course;

@end
