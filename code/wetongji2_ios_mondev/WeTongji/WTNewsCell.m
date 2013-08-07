//
//  WTNewsCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTNewsCell.h"
#import "News+Addition.h"

@implementation WTNewsCell

#define NEWS_TITLE_SUMMARY_LABEL_MARGIN 4.0f

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.titleLabel.highlighted = highlighted;
    self.categoryLabel.highlighted = highlighted;
    self.summaryLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.titleLabel.shadowOffset = labelShadowOffset;
    self.categoryLabel.shadowOffset = labelShadowOffset;
    self.summaryLabel.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              news:(News *)news {
    [super configureCellWithIndexPath:indexPath];
    
    if (news.hasTicket.boolValue) {
        self.ticketIconImageView.hidden = NO;
        self.titleLabel.text = [NSString stringWithFormat:@"    %@", news.title];
    } else {
        self.ticketIconImageView.hidden = YES;
        self.titleLabel.text = news.title;
    }
    self.categoryLabel.text = news.categoryString;
    self.summaryLabel.text = news.content;
        
    CGFloat titleLabelOriginalWidth = self.titleLabel.frame.size.width;
    CGFloat titleLabelRealWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat singleLineTitleLabelHeight = [@"Test" sizeWithFont:self.titleLabel.font].height;
    CGFloat singleLineSummaryLabelHeight = [@"Test" sizeWithFont:self.summaryLabel.font].height;
    
    if(titleLabelRealWidth > titleLabelOriginalWidth) {
        // 显示两行新闻标题
        [self.titleLabel resetHeight:singleLineTitleLabelHeight * 2];
        
        // 显示一行简介
        [self.summaryLabel resetHeight:singleLineSummaryLabelHeight];
    } else {
        // 显示一行新闻标题
        [self.titleLabel resetHeight:singleLineTitleLabelHeight];
        
        // 显示两行简介
        [self.summaryLabel resetHeight:singleLineSummaryLabelHeight * 2];
    }
    
    [self.summaryLabel resetOriginY:self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + NEWS_TITLE_SUMMARY_LABEL_MARGIN];
}

@end
