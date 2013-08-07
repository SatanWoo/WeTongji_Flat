//
//  WTCourseCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTHighlightableCell.h"

@class Course;

@interface WTCourseCell : WTHighlightableCell

@property (nonatomic, weak) IBOutlet UILabel *courseNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *teacherNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timetableLabel;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath course:(Course *)course;

@end
