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
    
    if (activity.image) {
        self.posterImageView.alpha = 1;
        [self.posterImageView loadImageWithImageURLString:activity.image];
        [self configureWithImageLayout];
        
    } else {
        [self configureNoImageLayout];
        self.posterImageView.alpha = 0;
    }
}


#define noImageIconOriginX 17
#define noImageLabelOriginX 42

#define maxRightLabelBorder 305
- (void)configureNoImageLayout
{
    [self.timeLabel resetOriginX:noImageLabelOriginX];
    [self resizeLableLength:self.timeLabel];
    
    [self.locationLabel resetOriginX:noImageLabelOriginX];
    [self resizeLableLength:self.locationLabel];
    
    [self.likeCountLabel resetOriginX:noImageLabelOriginX];
    
    [self.titleLabel resetOriginX:noImageIconOriginX];
    [self resizeLableLength:self.titleLabel];
     
    [self.timeIconImageView resetOriginX:noImageIconOriginX];
    [self.locationIconImageView resetOriginX:noImageIconOriginX];
    [self.likeIconImageView resetOriginX:noImageIconOriginX];
}

#define withImageIconOriginX 86
#define withImageLabelOriginX 111
- (void)configureWithImageLayout
{
    [self.timeLabel resetOriginX:withImageLabelOriginX];
    [self resizeLableLength:self.timeLabel];
    
    [self.locationLabel resetOriginX:withImageLabelOriginX];
    [self resizeLableLength:self.locationLabel];
    
    [self.likeCountLabel resetOriginX:withImageLabelOriginX];
    
    [self.titleLabel resetOriginX:withImageIconOriginX];
    [self resizeLableLength:self.titleLabel];
    
    [self.timeIconImageView resetOriginX:withImageIconOriginX];
    [self.likeIconImageView resetOriginX:withImageIconOriginX];
    [self.locationIconImageView resetOriginX:withImageIconOriginX];
}

- (void)resizeLableLength:(UILabel *)label
{
    [label resetWidth:maxRightLabelBorder - label.frame.origin.x];
}

@end
