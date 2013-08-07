//
//  WTCourseBaseDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTDetailViewController.h"

@class WTCourseBaseHeaderView;
@class Course;

@interface WTCourseBaseDetailViewController : WTDetailViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

#pragma mark - Methods to overwrite

- (WTCourseBaseHeaderView *)createHeaderView;

- (Course *)targetCourse;

@end
