//
//  WTCourseInstanceDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-9.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseInstanceDetailViewController.h"
#import "WTCourseInstanceHeaderView.h"
#import "Course+Addition.h"

@interface WTCourseInstanceDetailViewController ()

@property (nonatomic, strong) CourseInstance *courseInstance;

@end

@implementation WTCourseInstanceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTCourseBaseDetailViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (WTCourseInstanceDetailViewController *)createDetailViewControllerWithCourseInstance:(CourseInstance *)courseInstance
                                                                     backBarButtonText:(NSString *)backBarButtonText {
    if (!courseInstance)
        return nil;
    
    WTCourseInstanceDetailViewController *result = [[WTCourseInstanceDetailViewController alloc] init];
    
    result.courseInstance = courseInstance;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - Methods to overwrite

- (Course *)targetCourse {
    return self.courseInstance.course;
}

- (WTCourseBaseHeaderView *)createHeaderView {
    return [WTCourseInstanceHeaderView createHeaderViewWithCourseInstance:self.courseInstance];
}

- (LikeableObject *)targetObject {
    return self.courseInstance.course;
}

@end
