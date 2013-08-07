//
//  WTUserCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTUserCell.h"
#import "User+Addition.h"
#import "UIImageView+AsyncLoading.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTUserCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.nameLabel.highlighted = highlighted;
    self.schoolLabel.highlighted = highlighted;
    self.genderImageView.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.nameLabel.shadowOffset = labelShadowOffset;
    self.schoolLabel.shadowOffset = labelShadowOffset;
}
- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              user:(User *)user {
    [super configureCellWithIndexPath:indexPath];
    
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    [self.avatarImageView loadImageWithImageURLString:user.avatar];
    
    self.nameLabel.text = user.name;
    self.schoolLabel.text = user.department;
    if ([user.gender isEqualToString:@"男"]) {
        self.genderImageView.image = [UIImage imageNamed:@"WTGenderGrayMaleIcon"];
        self.genderImageView.highlightedImage = [UIImage imageNamed:@"WTGenderWhiteMaleIcon"];
    } else {
        self.genderImageView.image = [UIImage imageNamed:@"WTGenderGrayFemaleIcon"];
        self.genderImageView.highlightedImage = [UIImage imageNamed:@"WTGenderWhiteFemaleIcon"];
    }
}

@end
