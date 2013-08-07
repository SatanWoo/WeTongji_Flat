//
//  WTStarCell.m
//  WeTongji
//
//  Created by Song on 13-5-16.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTStarCell.h"
#import "Star+Addition.h"
#import "NSString+WTAddition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTStarCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.nameLabel.highlighted = highlighted;
    self.volumeLabel.highlighted = highlighted;
    self.mottoLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.nameLabel.shadowOffset = labelShadowOffset;
    self.volumeLabel.shadowOffset = labelShadowOffset;
    self.mottoLabel.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              Star:(Star *)star {
    [super configureCellWithIndexPath:indexPath];
    
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    [self.avatarImageView loadImageWithImageURLString:star.avatar];
    
    self.nameLabel.text = star.name;
    self.mottoLabel.text = star.motto;
    
    self.volumeLabel.text = [NSString volumeStringForVolumeNumber:star.volume];
    self.volumeLabel.textColor = [UIColor colorWithRed:12.0f / 255 green:192.0f / 255 blue:203.0f / 255 alpha:1.0f];
}

- (void)configureCurrentStarCell {
    self.volumeLabel.text = NSLocalizedString(@"Current Star", nil);
    self.volumeLabel.textColor = [UIColor colorWithRed:234.0f / 255 green:82.0f / 255 blue:81.0f / 255 alpha:1.0f];
}

@end
