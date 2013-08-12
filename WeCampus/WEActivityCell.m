//
//  WEActivityCell.m
//  WeCampus
//
//  Created by 吴 wuziqi on 13-8-12.
//  Copyright (c) 2013年 Ziqi Wu. All rights reserved.
//

#import "WEActivityCell.h"
#import "Activity+Addition.h"
#import "UIImageView+AsyncLoading.h"
#define kWEActivityCellNibName @"WEActivityCell"

@implementation WEActivityCell

+ (WEActivityCell *)createWEActivityCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:kWEActivityCellNibName owner:nil options:nil];
    WEActivityCell *cell = [array lastObject];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configureCellWithActivity:(Activity *)activity
{
    self.titleLabel.text = activity.what;
    self.timeLabel.text = activity.yearMonthDayBeginToEndTimeString;
    self.locationLabel.text = activity.where;
    self.likeCountLabel.text = activity.likeCount.stringValue;
    self.attendPeopleCountLabel.text = activity.friendsCount.stringValue;
    
    [self.posterImageView loadImageWithImageURLString:activity.image];
}

@end
