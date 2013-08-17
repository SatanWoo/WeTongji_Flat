//
//  WTSearchHistoryCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchHistoryCell.h"
#import "NSString+WTAddition.h"

@implementation WTSearchHistoryCell

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword
                    searchCategory:(NSInteger)category {
    if (keyword) {
        [self resetNormalLayout:keyword];
    } else {
        [self resetClearHistoryLayout];
    }
}

- (void)resetNormalLayout:(NSString *)keyword
{
    self.searchKeywordLabel.text = keyword;
    [self.searchKeywordLabel sizeToFit];
    self.searchIconImageView.hidden = NO;
}

- (void)resetClearHistoryLayout
{
    self.searchKeywordLabel.text = NSLocalizedString(@"Clear search history", nil);
    [self.searchKeywordLabel sizeToFit];
    [self.searchKeywordLabel resetCenterX:self.frame.size.width / 2];
    self.searchIconImageView.hidden = YES;
}

@end
