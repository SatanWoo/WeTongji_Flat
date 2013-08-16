//
//  WTNowBaseCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowBaseCell.h"
#import "OHAttributedLabel.h"
#import "Event.h"
#import "UIApplication+WTAddition.h"
//#import "WENowViewController.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+WTAddition.h"
#import "Activity+Addition.h"
#import "Course+Addition.h"
#import "NSDate+WTAddition.h"

@interface WTNowBaseCell ()

@property (nonatomic, weak) Event *event;

@end

@implementation WTNowBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    
}

- (void)configureCellWithEvent:(Event *)event {
    self.event = event;
    self.whereLabel.text = self.event.where;
    self.eventNameLabel.text = event.what;
    self.startTimeLabel.text = [self.event.beginTime convertToTimeString];
    self.endTimeLabel.text = [self.event.endTime convertToTimeString];
    NSLog(@"Begin~~~~:%@",self.event.beginTime);
}

#pragma mark - UI methods

- (void)setCellPast:(BOOL)past {
    if (past)
    {
        [self.startTimeLabel setTextColor:[UIColor appNowEventPastStartTimeLabelColor]];
    }
    else
    {
        UIColor *color;
        if ([self.event isKindOfClass:[Activity class]]) {
            color = [UIColor appNowActivityEventStartTimeLabelColor];
        } else if ([self.event isKindOfClass:[CourseInstance class]]){
            color = [UIColor appNowCourseEventStartTimeLabelColor];
        }
        [self.startTimeLabel setTextColor:color];
    }
}

- (void)updateCellStatus:(WTNowBaseCellType)type {
    if (type == WTNowBaseCellTypePast) {
        [self setCellPast:YES];
    } else {
        [self setCellPast:NO];
    }
}

#pragma mark - Actions

- (IBAction)didClickBgButton:(UIButton *)sender {
//    WTNowViewController *nowViewControler = [UIApplication sharedApplication].nowViewController;
//    [nowViewControler showNowItemDetailViewWithEvent:self.event];
}

@end
