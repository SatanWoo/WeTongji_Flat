//
//  Course+Addtion.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Course.h"

@interface Course (Addtion)

+ (Course *)insertCourse:(NSDictionary *)dic;

+ (Course *)courseWithCourseNO:(NSString *)courseNO;

@end
