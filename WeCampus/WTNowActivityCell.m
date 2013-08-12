//
//  WTNowActivityCell.m
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNowActivityCell.h"
#import "UIImageView+AsyncLoading.h"
#import "Activity.h"
#import "Event+Addition.h"

@implementation WTNowActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - UI methods

- (void)setCellPast:(BOOL)past {
    [super setCellPast:past];
    
    if (past) {
        self.posterContainerView.alpha = 0.5f;
        self.activityNameLabel.highlighted = YES;
        self.activityNameLabel.shadowOffset = CGSizeZero;
    } else {
        self.posterContainerView.alpha = 1.0f;
        self.activityNameLabel.highlighted = NO;
        self.activityNameLabel.shadowOffset = CGSizeMake(0, 1);
    }
}

#define ACTIVITY_WHERE_LABEL_MIN_TOP_INDENT 6.0f
#define ACTIVITY_NAME_LABEL_MAX_HEIGHT      43.0f
#define ACTIVITY_LABEL_DEFAULT_ORIGIN_Y     34.0f
#define ACTIVITY_NAME_LABEL_WIDTH           210.0f
#define WHERE_LABEL_DEFAULT_ORIGIN_Y        78.0f

- (void)configureCellWithEvent:(Event *)event {
    [super configureCellWithEvent:event];
    
    if (![event isKindOfClass:[Activity class]])
        return;
    Activity *activity = (Activity *)event;
    self.whenLabel.text = activity.beginToEndTimeString;
    
    self.whereLabel.text = activity.where;
    
    self.activityNameLabel.text = activity.what;
    [self.activityNameLabel resetWidth:ACTIVITY_NAME_LABEL_WIDTH];
    [self.activityNameLabel sizeToFit];
    
    if (self.activityNameLabel.frame.size.height > ACTIVITY_NAME_LABEL_MAX_HEIGHT)
        [self.activityNameLabel resetHeight:ACTIVITY_NAME_LABEL_MAX_HEIGHT];
    
    [self.activityNameLabel resetOriginY:ACTIVITY_LABEL_DEFAULT_ORIGIN_Y];
    [self.whereLabel resetOriginY:WHERE_LABEL_DEFAULT_ORIGIN_Y];
    
    if (self.whereLabel.frame.origin.y - self.activityNameLabel.frame.origin.y - self.activityNameLabel.frame.size.height < ACTIVITY_WHERE_LABEL_MIN_TOP_INDENT) {
        [self.activityNameLabel resetOriginY:self.whereLabel.frame.origin.y - self.activityNameLabel.frame.size.height - ACTIVITY_WHERE_LABEL_MIN_TOP_INDENT];
    } else {
        [self.activityNameLabel resetOriginY:ACTIVITY_LABEL_DEFAULT_ORIGIN_Y];
        [self.whereLabel resetOriginY:WHERE_LABEL_DEFAULT_ORIGIN_Y - 2.0f];
    }
    
    self.posterPlaceholderImageView.alpha = 1.0f;
    [self.posterImageView loadImageWithImageURLString:activity.image success:^(UIImage *image) {
        self.posterImageView.image = image;
        [self.posterImageView fadeIn];
        self.posterPlaceholderImageView.alpha = 0;
    } failure:nil];
}

@end
