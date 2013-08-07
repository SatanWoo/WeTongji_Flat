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

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    self.searchKeywordLabel.highlighted = highlighted;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.searchKeywordLabel.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword
                    searchCategory:(NSInteger)category {
    [super configureCellWithIndexPath:indexPath];
    
    if (keyword) {
        self.searchCategoryTagContainerView.hidden = NO;
        
        self.searchCategoryTagImageView.image = [[UIImage imageNamed:@"WTSearchTagBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4.0f, 0, 4.0f)];
        
        NSString *categoryString = [NSString searchCategoryStringForCategory:category];
        self.searchCategoryLabel.text = categoryString;
        [self.searchCategoryLabel sizeToFit];
        [self.searchCategoryLabel resetHeight:self.searchCategoryTagContainerView.frame.size.height];
        [self.searchCategoryLabel resetWidth:self.searchCategoryLabel.frame.size.width + 12.0f];
        [self.searchCategoryTagContainerView resetWidth:self.searchCategoryLabel.frame.size.width];
        
        self.searchKeywordLabel.text = keyword;
        [self.searchKeywordLabel resetOriginX:self.searchCategoryTagContainerView.frame.origin.x + self.searchCategoryTagContainerView.frame.size.width + 12.0f];
    } else {
        self.searchCategoryTagContainerView.hidden = YES;
        self.searchKeywordLabel.text = NSLocalizedString(@"Clear search history", nil);
        [self.searchKeywordLabel resetOriginX:self.searchCategoryTagContainerView.frame.origin.x];
    }
    
}

@end
