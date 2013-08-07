//
//  WTCourseInstanceHeaderView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseInstanceHeaderView.h"
#import "Course+Addition.h"
#import "WTResourceFactory.h"
#import "NSString+WTAddition.h"

@interface WTCourseInstanceHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UIImageView *locationDisclosureImageView;

@property (nonatomic, weak) CourseInstance *courseInstance;

@end

@implementation WTCourseInstanceHeaderView

+ (WTCourseInstanceHeaderView *)createHeaderViewWithCourseInstance:(CourseInstance *)courseInstance {
    WTCourseInstanceHeaderView *result = [[NSBundle mainBundle] loadNibNamed:@"WTCourseInstanceHeaderView" owner:nil options:nil].lastObject;
    
    result.courseInstance = courseInstance;
    
    [result configureView];
    
    return result;
}

#pragma mark - Methods to overwrite

- (Course *)targetCourse {
    return self.courseInstance.course;
}

- (void)configureView {
    [super configureView];
    [self configureLocationButton];
    [self configureTimeLabel];
}

#pragma mark - UI methods

- (void)configureTimeLabel {
    self.timeLabel.text = self.courseInstance.yearMonthDayBeginToEndTimeString;
}

- (void)configureLocationButton {
    [self.locationButton setTitle:self.courseInstance.where forState:UIControlStateNormal];
    CGFloat locationButtonHeight = self.locationButton.frame.size.height;
    CGFloat locationButtonCenterY = self.locationButton.center.y;
    CGFloat locationButtonRightBoundX = self.locationButton.frame.origin.x + self.locationButton.frame.size
    .width;
    [self.locationButton sizeToFit];
    
    CGFloat maxLocationButtonWidth = 282.0f;
    if (self.locationButton.frame.size.width > maxLocationButtonWidth) {
        [self.locationButton resetWidth:maxLocationButtonWidth];
    }
    
    [self.locationButton resetHeight:locationButtonHeight];
    [self.locationButton resetCenterY:locationButtonCenterY];
    [self.locationButton resetOriginX:locationButtonRightBoundX - self.locationButton.frame.size.width];
}

@end
