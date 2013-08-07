//
//  WTActivityCell.h
//  WeTongji
//
//  Created by Shen Yuncheng on 1/21/13.
//  Copyright (c) 2013 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTHighlightableCell.h"

@class Activity;

@interface WTActivityCell : WTHighlightableCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;

- (void)configureCellWithIndexPath:(NSIndexPath *)indexPath
                          activity:(Activity *)activity;
@end
