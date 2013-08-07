//
//  WTSearchHintCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-5-8.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTHighlightableCell.h"

@class OHAttributedLabel;

@interface WTSearchHintCell : WTHighlightableCell

@property (nonatomic, weak) IBOutlet OHAttributedLabel *label;
@property (nonatomic, weak) IBOutlet UIView *containerView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                     searchKeyword:(NSString *)keyword;

@end
