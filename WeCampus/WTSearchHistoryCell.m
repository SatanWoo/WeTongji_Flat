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
        self.searchKeywordLabel.text = keyword;
        self.searchIconImageView.hidden = NO;
    } else {
        self.searchKeywordLabel.text = NSLocalizedString(@"Clear search history", nil);
        self.searchIconImageView.hidden = YES;
    }
}

@end
