//
//  WTCourseProfileView.h
//  WeTongji
//
//  Created by 王 紫川 on 13-6-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface WTCourseProfileView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *firstSectionBgImageView;
@property (nonatomic, weak) IBOutlet UIView *firstSectionContainerView;
@property (nonatomic, weak) IBOutlet UILabel *courseInformationDisplayLabel;

@property (nonatomic, weak) IBOutlet UILabel *teacherDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *courseNumberDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *creditDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *hoursDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeDisplayLabel;

@property (nonatomic, weak) IBOutlet UILabel *teacherLabel;
@property (nonatomic, weak) IBOutlet UILabel *courseNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *creditLabel;
@property (nonatomic, weak) IBOutlet UILabel *hoursLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;

+ (WTCourseProfileView *)createProfileViewWithCourse:(Course *)course;

@end
