//
//  WTCourseHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-2.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseHeaderView.h"
#import "Course+Addition.h"

@interface WTCourseHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *semesterLabel;

@property (nonatomic, weak) Course *course;

@end

@implementation WTCourseHeaderView

+ (WTCourseHeaderView *)createHeaderViewWithCourse:(Course *)course {
    WTCourseHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTCourseHeaderView" owner:nil options:nil].lastObject;
    
    result.course = course;
    
    [result configureView];
    
    return result;
}

#pragma mark - Methods to overwrite

- (Course *)targetCourse {
    return self.course;
}

- (void)configureView {
    [super configureView];
    [self configureSemesterLabel];
}

#pragma mark - UI methods

- (void)configureSemesterLabel {
    self.semesterLabel.text = self.course.yearSemesterString;
}

@end
