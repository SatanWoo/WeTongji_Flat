//
//  WTSearchHintCell.m
//  WeTongji
//
//  Created by 王 紫川 on 13-5-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTSearchHintCell.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+WTAddition.h"
#import "NSString+WTAddition.h"

@implementation WTSearchHintCell

- (void)configureCellWithHighlightStatus:(BOOL)highlighted {
    [super configureCellWithHighlightStatus:highlighted];
    
    NSMutableAttributedString *attributedString = [NSMutableAttributedString attributedStringWithAttributedString:self.label.attributedText];
    
    [attributedString setTextColor:highlighted ? [UIColor whiteColor] : [UIColor colorWithRed:64.0f / 255 green:64.0f / 255 blue:64.0f / 255 alpha:1.0f]];
    
    self.label.attributedText = attributedString;
    
    CGSize labelShadowOffset = highlighted ? CGSizeZero : CGSizeMake(0, 1.0f);
    self.label.shadowOffset = labelShadowOffset;
}

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword {
    [super configureCellWithIndexPath:indexPath];
    
    NSMutableAttributedString *labelAttributedString = nil;
    
    if (indexPath.row == 0) {
        
        NSString *cellLabelString = NSLocalizedString(@"Search all", nil);
        labelAttributedString = [NSMutableAttributedString attributedStringWithString:cellLabelString];
        [labelAttributedString setAttributes:[self.label.attributedText attributesAtIndex:0 effectiveRange:NULL] range:NSMakeRange(0, labelAttributedString.length)];

    } else {
        NSString *categoryString = [NSString searchCategoryStringForCategory:indexPath.row];
        labelAttributedString = [NSMutableAttributedString attributedStringWithAttributedString:[NSAttributedString searchHintStringForKeyword:keyword category:categoryString attributes:[self.label.attributedText attributesAtIndex:0 effectiveRange:NULL]]];
    }
    
    self.label.attributedText = labelAttributedString;
}

@end
