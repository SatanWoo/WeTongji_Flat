//
//  WTCourseCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseCell.h"
#import "Course+Addition.h"

@implementation WTCourseCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.courseNameLabel.highlighted = highlighted;
    self.teacherNameLabel.highlighted = highlighted;
    self.timetableLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.courseNameLabel.shadowOffset = labelShadowOffset;
    self.teacherNameLabel.shadowOffset = labelShadowOffset;
    self.timetableLabel.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath course:(Course *)course {
    [super configureCellWithIndexPath:indexPath];
    self.courseNameLabel.text = course.courseName;
    self.teacherNameLabel.text = course.teacher;
    self.timetableLabel.text = course.timetableString;
}

@end
