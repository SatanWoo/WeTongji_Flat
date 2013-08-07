//
//  WTCourseDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-7-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseBaseDetailViewController.h"

@interface WTCourseDetailViewController : WTCourseBaseDetailViewController

+ (WTCourseDetailViewController *)createDetailViewControllerWithCourse:(Course *)course
                                                     backBarButtonText:(NSString *)backBarButtonText;

@end
