//
//  WTCommentCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-24.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTCommentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AsyncLoading.h"
#import "Comment+Addition.h"
#import "User+Addition.h"
#import "NSString+WTAddition.h"

@implementation WTCommentCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.commentLabel.highlighted = highlighted;
    self.timeLabel.highlighted = highlighted;
    self.authorLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.commentLabel.shadowOffset = labelShadowOffset;
    self.timeLabel.shadowOffset = labelShadowOffset;
    self.authorLabel.shadowOffset = labelShadowOffset;
}

- (void)awakeFromNib {
    [self configureAvatarView];
}

- (void)configureAvatarView {
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = 3.0f;
}

- (void)configureViewWithIndexPath:(NSIndexPath *)indexPath comment:(Comment *)comment {
    [super configureCellWithIndexPath:indexPath];
    self.commentLabel.text = comment.content;
    self.authorLabel.text = comment.author.name;
    self.timeLabel.text = [comment.createdAt convertToYearMonthDayWeekString];
    [self.avatarImageView loadImageWithImageURLString:comment.author.avatar];
}

@end
