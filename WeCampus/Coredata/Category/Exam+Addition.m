//
//  Exam+Addition.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Exam+Addition.h"
#import "WTCoreDataManager.h"
#import "NSString+WTAddition.h"
#import "LikeableObject+Addition.h"
#import "Course+Addition.h"

@implementation Exam (Addition)

+ (Exam *)insertExam:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]])
        return nil;
    
    if (!dict[@"NO"]) {
        return nil;
    }
    
    Course *course = [Course insertCourse:dict[@"CourseDetails"]];
    if (!course)
        return nil;
    
    NSString *examID = course.identifier;
    
    Exam *result = [Exam examWithID:examID];
    if (!result) {
        result = [NSEntityDescription insertNewObjectForEntityForName:@"Exam"
                                             inManagedObjectContext:[WTCoreDataManager sharedManager].managedObjectContext];
        result.identifier = examID;
        result.objectClass = NSStringFromClass([Exam class]);
    }
    
    result.updatedAt = [NSDate date];
    
    result.course = course;
    result.beginTime = [[NSString stringWithFormat:@"%@", dict[@"Begin"]] convertToDate];
    result.endTime = [[NSString stringWithFormat:@"%@", dict[@"End"]] convertToDate];
    
    result.what = course.courseName;
    result.where = [NSString stringWithFormat:@"%@", dict[@"Location"]];
    result.friendsCount = course.friendsCount;
    
    result.beginDay = [result.beginTime convertToYearMonthDayString];
    
    // [result configureLikeInfo:dict];
    // [result configureScheduleInfo:dict];
    
    return result;
}

+ (Exam *)examWithID:(NSString *)examID {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exam"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", examID];
    NSManagedObjectContext *context = [WTCoreDataManager sharedManager].managedObjectContext;
    NSArray *matches = [context executeFetchRequest:request error:nil];
    
    return [matches lastObject];
}

@end
