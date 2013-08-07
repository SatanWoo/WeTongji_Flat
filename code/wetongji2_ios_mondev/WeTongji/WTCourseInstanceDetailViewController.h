//
//  WTCourseInstanceDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTCourseBaseDetailViewController.h"

@class CourseInstance;

@interface WTCourseInstanceDetailViewController : WTCourseBaseDetailViewController

+ (WTCourseInstanceDetailViewController *)createDetailViewControllerWithCourseInstance:(CourseInstance *)courseInstance
                                                                     backBarButtonText:(NSString *)backBarButtonText;

@end
