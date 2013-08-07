//
//  WTHighlightableCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-30.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTHighlightableCell.h"

@implementation WTHighlightableCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {    
    self.highlightBgView.alpha = highlighted ? 1.0f : 0;
    self.disclosureImageView.highlighted = highlighted;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.highlighted == highlighted)
        return;
    [super setHighlighted:highlighted animated:animated];
    
    if (!highlighted && animated) {
        [UIView animateWithDuration:0.5f animations:^{
            [self configureCellWithHighlightStatus:highlighted];
        }];
    } else {
        [self configureCellWithHighlightStatus:highlighted];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected)
        return;
    [super setSelected:selected animated:animated];
    
    [self setHighlighted:selected animated:animated];
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2) {
        self.containerView.backgroundColor = WTCellBackgroundColor1;
    } else {
        self.containerView.backgroundColor = WTCellBackgroundColor2;
    }
    
    if (indexPath.row == 0) {
        self.topSeperatorImageView.hidden = YES;
    } else {
        self.topSeperatorImageView.hidden = NO;
    }
}

@end
