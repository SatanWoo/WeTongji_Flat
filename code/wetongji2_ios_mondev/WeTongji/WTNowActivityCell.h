//
//  WTNowActivityCell.h
//  WeTongji
//
//  Created by 吴 wuziqi on 13-1-4.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTNowBaseCell.h"

@interface WTNowActivityCell : WTNowBaseCell

@property (nonatomic, weak) IBOutlet UIView *posterContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *posterPlaceholderImageView;
@property (nonatomic, weak) IBOutlet UIImageView *posterImageView;
@property (nonatomic, weak) IBOutlet UILabel *activityNameLabel;

@end
