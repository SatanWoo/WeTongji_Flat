//
//  CourseTimetable.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Object.h"

@class Course;

@interface CourseTimetable : Object

@property (nonatomic, retain) NSNumber * endSection;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * startSection;
@property (nonatomic, retain) NSNumber * weekDay;
@property (nonatomic, retain) NSString * weekType;
@property (nonatomic, retain) Course *belongTo;

@end
