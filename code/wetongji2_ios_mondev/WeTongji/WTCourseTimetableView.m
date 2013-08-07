//
//  WTCourseTimetableView.m
//  WeTongji
//
//  Created by 王 紫川 on 13-7-3.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCourseTimetableView.h"
#import "Course+Addition.h"

@interface WTCourseTimetableContainerView ()

@property (nonatomic, weak) IBOutlet UILabel *courseTimetableDisplayLabel;

@property (nonatomic, weak) Course *course;

@end

@implementation WTCourseTimetableContainerView

+ (WTCourseTimetableContainerView *)createViewWithCourse:(Course *)course; {
    WTCourseTimetableContainerView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTCourseTimetableView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTCourseTimetableContainerView class]]) {
            result = (WTCourseTimetableContainerView *)view;
            break;
        }
    }
    
    result.course = course;
    
    [result configureView];
    
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    
    self.courseTimetableDisplayLabel.text = NSLocalizedString(@"Course Timetable", nil);
    
    NSArray *timetableArray = self.course.timetableArray;
    for (int i = 0; i < timetableArray.count; i++) {
        CourseTimetable *timetable = timetableArray[i];
        WTCourseTimetableItemView *itemView = [WTCourseTimetableItemView createViewWithCourseTimetable:timetable];
        [itemView resetOriginY:self.courseTimetableDisplayLabel.frame.size.height + i * itemView.frame.size.height];
        [self addSubview:itemView];
        
        if (i == timetableArray.count - 1) {
            [self resetHeight:itemView.frame.size.height + itemView.frame.origin.y];
        }
    }
}

@end

@interface WTCourseTimetableItemView ()

@property (nonatomic, weak) IBOutlet UILabel *timeDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationDisplayLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

@property (nonatomic, weak) CourseTimetable *timetable;

@end

@implementation WTCourseTimetableItemView

+ (WTCourseTimetableItemView *)createViewWithCourseTimetable:(CourseTimetable *)timetable {
    WTCourseTimetableItemView *result = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WTCourseTimetableView" owner:nil options:nil];
    for (UIView *view in views) {
        if ([view isKindOfClass:[WTCourseTimetableItemView class]]) {
            result = (WTCourseTimetableItemView *)view;
            break;
        }
    }
    
    result.timetable = timetable;
    
    [result configureView];
    
    return result;
}

#pragma mark - UI methods

- (void)configureView {
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 7.0, 8.0, 7.0);
    UIImage *bgImage = [[UIImage imageNamed:@"WTInfoPanelBg"] resizableImageWithCapInsets:insets];
    self.bgImageView.image = bgImage;
    
    self.timeDisplayLabel.text = NSLocalizedString(@"Class time", nil);
    self.typeDisplayLabel.text = NSLocalizedString(@"Week type", nil);
    self.locationDisplayLabel.text = NSLocalizedString(@"Location", nil);
    
    self.timeLabel.text = self.timetable.timeString;
    self.typeLabel.text = self.timetable.weekType;
    self.locationLabel.text = self.timetable.location;
}

@end