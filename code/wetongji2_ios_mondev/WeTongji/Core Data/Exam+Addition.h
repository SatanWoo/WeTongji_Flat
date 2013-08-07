//
//  Exam+Addition.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-3-5.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "Exam.h"
#import "Course+Addition.h"

@interface Exam (Addition)

+ (Exam *)insertExam:(NSDictionary *)dict;

+ (Exam *)examWithID:(NSString *)examID;

@end
