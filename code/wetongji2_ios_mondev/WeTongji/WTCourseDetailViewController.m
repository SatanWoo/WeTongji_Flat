//
//  WTCourseDetailViewController.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseDetailViewController.h"
#import "WTCourseHeaderView.h"
#import "Course+Addition.h"

@interface WTCourseDetailViewController ()

@property (nonatomic, strong) Course *course;

@end

@implementation WTCourseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"WTCourseBaseDetailViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (WTCourseDetailViewController *)createDetailViewControllerWithCourse:(Course *)course
                                                     backBarButtonText:(NSString *)backBarButtonText {
    WTCourseDetailViewController *result = [[WTCourseDetailViewController alloc] init];
    
    result.course = course;
    
    result.backBarButtonText = backBarButtonText;
    
    return result;
}

#pragma mark - Methods to overwrite

- (WTCourseBaseHeaderView *)createHeaderView {
    return [WTCourseHeaderView createHeaderViewWithCourse:self.course];
}

- (Course *)targetCourse {
    return self.course;
}

- (LikeableObject *)targetObject {
    return self.course;
}

@end
