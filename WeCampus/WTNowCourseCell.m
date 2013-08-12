//
//  WTNowBaseCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowCourseCell.h"
#import "Event+Addition.h"
#import "Course+Addition.h"

@implementation WTNowCourseCell

#define COURSE_NAME_LABEL_WIDTH 260.0f

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - UI methods

- (void)setCellPast:(BOOL)past {
    [super setCellPast:past];
    
    if (past) {
        self.courseNameLabel.highlighted = YES;
        self.courseNameLabel.shadowOffset = CGSizeZero;
    } else {
        self.courseNameLabel.highlighted = NO;
        self.courseNameLabel.shadowOffset = CGSizeMake(0, 1);
    }
}

- (void)configureCellWithEvent:(Event *)event {
    [super configureCellWithEvent:event];
    
    if (![event isKindOfClass:[CourseInstance class]])
        return;
    
    self.courseNameLabel.text = event.what;
    [self.courseNameLabel resetWidth:COURSE_NAME_LABEL_WIDTH];
    [self.courseNameLabel sizeToFit];
    
    self.whenLabel.text = event.beginToEndTimeString;
    self.whereLabel.text = event.where;
}

@end
