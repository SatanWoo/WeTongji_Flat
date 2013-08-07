//
//  WTOrganizationCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTOrganizationCell.h"
#import "UIImageView+AsyncLoading.h"
#import "Organization+Addition.h"
#import <QuartzCore/QuartzCore.h>

@implementation WTOrganizationCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.nameLabel.highlighted = highlighted;
    self.aboutLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.nameLabel.shadowOffset = labelShadowOffset;
    self.aboutLabel.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                      organization:(Organization *)org {
    [super configureCellWithIndexPath:indexPath];
    
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 6.0f;
    [self.avatarImageView loadImageWithImageURLString:org.avatar];
    
    self.nameLabel.text = org.name;
    self.aboutLabel.text = org.about;
}

@end
