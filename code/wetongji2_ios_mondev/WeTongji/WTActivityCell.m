//
//  WTActivityCell.m
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import "WTActivityCell.h"
#import "UIImageView+AsyncLoading.h"
#import "Activity+Addition.h"

@interface WTActivityCell ()

@end

@implementation WTActivityCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.titleLabel.highlighted = highlighted;
    self.timeLabel.highlighted = highlighted;
    self.locationLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.titleLabel.shadowOffset = labelShadowOffset;
    self.timeLabel.shadowOffset = labelShadowOffset;
    self.locationLabel.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath activity:(Activity *)activity {
    [super configureCellWithIndexPath:indexPath];
    self.titleLabel.text = activity.what;
    self.timeLabel.text = activity.yearMonthDayBeginToEndTimeString;
    self.locationLabel.text = activity.where;
    [self.posterImageView loadImageWithImageURLString:activity.image];
}

@end
