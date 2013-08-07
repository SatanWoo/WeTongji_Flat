//
//  WTNewsCell.h
//  WeTongji
//
//  Created by 王 紫川 on 13-1-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTHighlightableCell.h"

@class News;

@interface WTNewsCell : WTHighlightableCell

@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *summaryLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIImageView *ticketIconImageView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                              news:(News *)news;

@end
