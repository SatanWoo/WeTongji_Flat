//
//  WTSearchHistoryCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-12.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTHighlightableCell.h"

@interface WTSearchHistoryCell : WTHighlightableCell

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *searchKeywordLabel;
@property (nonatomic, weak) IBOutlet UIView *searchCategoryTagContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *searchCategoryTagImageView;
@property (nonatomic, weak) IBOutlet UILabel *searchCategoryLabel;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword
                    searchCategory:(NSInteger)category;

@end
